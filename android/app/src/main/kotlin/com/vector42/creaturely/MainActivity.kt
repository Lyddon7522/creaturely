package com.vector42.creaturely

import android.app.Activity
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import com.google.android.gms.auth.api.identity.AuthorizationRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.Scope
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.io.DataOutputStream
import java.net.HttpURLConnection
import java.net.URI
import java.net.URLEncoder
import java.nio.charset.StandardCharsets
import java.util.concurrent.Executors

/**
 * Explicit recovery bridge for Google Drive's hidden appDataFolder.
 *
 * No request is made until Flutter calls one of these methods after keeper opt-in.
 * Creaturely requests only drive.appdata, never broad Drive access.
 */
class MainActivity : FlutterActivity() {
    private val channelName = "com.vector42.creaturely/recovery"
    private val authorizationRequestCode = 42042
    private val appDataScope = Scope("https://www.googleapis.com/auth/drive.appdata")
    private val executor = Executors.newSingleThreadExecutor()
    private var pendingAuthorization: MethodChannel.Result? = null

    private val authorizationRequest: AuthorizationRequest
        get() = AuthorizationRequest.builder()
            .setRequestedScopes(listOf(appDataScope))
            .build()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler(::handleRecoveryCall)
    }

    override fun onDestroy() {
        executor.shutdown()
        super.onDestroy()
    }

    private fun handleRecoveryCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "status" -> checkAuthorization(result, launchResolution = false)
            "authorize" -> checkAuthorization(result, launchResolution = true)
            "upload" -> withAccessToken(result) { token ->
                val id = call.argument<String>("id")
                    ?: throw IllegalArgumentException("Snapshot id is required")
                val bytes = call.argument<ByteArray>("bytes")
                    ?: throw IllegalArgumentException("Snapshot bytes are required")
                val createdAt = call.argument<String>("createdAt")
                    ?: throw IllegalArgumentException("Snapshot date is required")
                createDriveFile(token, id, createdAt, bytes)
                null
            }
            "list" -> withAccessToken(result) { token -> listDriveFiles(token) }
            "download" -> withAccessToken(result) { token ->
                val id = call.argument<String>("id")
                    ?: throw IllegalArgumentException("Drive file id is required")
                driveRequest(
                    token = token,
                    method = "GET",
                    url = "https://www.googleapis.com/drive/v3/files/" +
                        "${encode(id)}?alt=media",
                    expected = setOf(200),
                )
            }
            "delete" -> withAccessToken(result) { token ->
                val id = call.argument<String>("id")
                    ?: throw IllegalArgumentException("Drive file id is required")
                driveRequest(
                    token = token,
                    method = "DELETE",
                    url = "https://www.googleapis.com/drive/v3/files/${encode(id)}",
                    expected = setOf(204),
                )
                null
            }
            else -> result.notImplemented()
        }
    }

    private fun checkAuthorization(result: MethodChannel.Result, launchResolution: Boolean) {
        if (!isOnline()) {
            result.success("offline")
            return
        }
        Identity.getAuthorizationClient(this)
            .authorize(authorizationRequest)
            .addOnSuccessListener { authorization ->
                if (!authorization.hasResolution()) {
                    result.success("available")
                } else if (!launchResolution) {
                    result.success("signedOut")
                } else {
                    val pendingIntent = authorization.pendingIntent
                    if (pendingIntent == null) {
                        result.success("permissionDenied")
                        return@addOnSuccessListener
                    }
                    pendingAuthorization = result
                    try {
                        startIntentSenderForResult(
                            pendingIntent.intentSender,
                            authorizationRequestCode,
                            null,
                            0,
                            0,
                            0,
                        )
                    } catch (error: Exception) {
                        pendingAuthorization = null
                        result.error("permissionDenied", error.message, null)
                    }
                }
            }
            .addOnFailureListener { error ->
                result.success(mapAuthorizationError(error))
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != authorizationRequestCode) return
        val callback = pendingAuthorization ?: return
        pendingAuthorization = null
        if (resultCode != Activity.RESULT_OK || data == null) {
            callback.success("permissionDenied")
            return
        }
        try {
            val authorization = Identity.getAuthorizationClient(this)
                .getAuthorizationResultFromIntent(data)
            callback.success(
                if (authorization.accessToken.isNullOrBlank()) "permissionDenied" else "available",
            )
        } catch (error: ApiException) {
            callback.error("permissionDenied", error.message, error.statusCode)
        }
    }

    private fun withAccessToken(
        result: MethodChannel.Result,
        operation: (String) -> Any?,
    ) {
        if (!isOnline()) {
            result.error("offline", "Google Drive is offline", null)
            return
        }
        Identity.getAuthorizationClient(this)
            .authorize(authorizationRequest)
            .addOnSuccessListener { authorization ->
                val token = authorization.accessToken
                if (authorization.hasResolution() || token.isNullOrBlank()) {
                    result.error("signedOut", "Google Drive appData access is not authorized", null)
                    return@addOnSuccessListener
                }
                executor.execute {
                    try {
                        val value = operation(token)
                        runOnUiThread { result.success(value) }
                    } catch (error: DriveRecoveryException) {
                        runOnUiThread {
                            result.error(error.code, error.message, error.httpStatus)
                        }
                    } catch (error: Exception) {
                        runOnUiThread {
                            result.error("unknownError", error.message, null)
                        }
                    }
                }
            }
            .addOnFailureListener { error ->
                result.error(mapAuthorizationError(error), error.message, null)
            }
    }

    private fun createDriveFile(
        token: String,
        id: String,
        createdAt: String,
        bytes: ByteArray,
    ) {
        val boundary = "creaturely-${System.currentTimeMillis()}"
        val metadata = JSONObject()
            .put("name", id)
            .put("parents", JSONArray().put("appDataFolder"))
            .put(
                "appProperties",
                JSONObject()
                    .put("createdAt", createdAt)
                    .put("format", "creaturely-backup-v1"),
            )
        val body = ByteArrayOutputStream()
        DataOutputStream(body).use { output ->
            output.writeBytes("--$boundary\r\n")
            output.writeBytes("Content-Type: application/json; charset=UTF-8\r\n\r\n")
            output.write(metadata.toString().toByteArray(StandardCharsets.UTF_8))
            output.writeBytes("\r\n--$boundary\r\n")
            output.writeBytes("Content-Type: application/zip\r\n\r\n")
            output.write(bytes)
            output.writeBytes("\r\n--$boundary--\r\n")
        }
        driveRequest(
            token = token,
            method = "POST",
            url = "https://www.googleapis.com/upload/drive/v3/files" +
                "?uploadType=multipart&fields=id",
            contentType = "multipart/related; boundary=$boundary",
            body = body.toByteArray(),
            expected = setOf(200, 201),
        )
    }

    private fun listDriveFiles(token: String): List<Map<String, Any>> {
        val fields = encode("files(id,name,size,createdTime,appProperties)")
        val bytes = driveRequest(
            token = token,
            method = "GET",
            url = "https://www.googleapis.com/drive/v3/files" +
                "?spaces=appDataFolder&pageSize=1000&fields=$fields",
            expected = setOf(200),
        )
        val files = JSONObject(String(bytes, StandardCharsets.UTF_8)).getJSONArray("files")
        return buildList {
            for (index in 0 until files.length()) {
                val file = files.getJSONObject(index)
                val properties = file.optJSONObject("appProperties")
                add(
                    mapOf(
                        "id" to file.getString("id"),
                        "createdAt" to (
                            properties?.optString("createdAt")
                                ?.takeIf { it.isNotBlank() }
                                ?: file.getString("createdTime")
                            ),
                        "byteLength" to file.optString("size", "0").toLong(),
                    ),
                )
            }
        }
    }

    private fun driveRequest(
        token: String,
        method: String,
        url: String,
        contentType: String? = null,
        body: ByteArray? = null,
        expected: Set<Int>,
    ): ByteArray {
        val connection = URI(url).toURL().openConnection() as HttpURLConnection
        try {
            connection.requestMethod = method
            connection.setRequestProperty("Authorization", "Bearer $token")
            connection.setRequestProperty("Accept", "application/json")
            connection.connectTimeout = 20_000
            connection.readTimeout = 60_000
            if (body != null) {
                connection.doOutput = true
                connection.setRequestProperty("Content-Type", contentType)
                connection.setFixedLengthStreamingMode(body.size)
                connection.outputStream.use { it.write(body) }
            }
            val status = connection.responseCode
            val stream = if (status in expected) connection.inputStream else connection.errorStream
            val response = stream?.use { it.readBytes() } ?: ByteArray(0)
            if (status !in expected) {
                val message = String(response, StandardCharsets.UTF_8)
                val code = when {
                    status == 401 -> "signedOut"
                    status == 403 && (
                        message.contains("storageQuotaExceeded") ||
                            message.contains("quota", ignoreCase = true)
                        ) -> "quotaExceeded"
                    status == 403 -> "permissionDenied"
                    status >= 500 -> "offline"
                    status == 409 -> "conflict"
                    else -> "unknownError"
                }
                throw DriveRecoveryException(code, "Drive request failed ($status): $message", status)
            }
            return response
        } finally {
            connection.disconnect()
        }
    }

    private fun isOnline(): Boolean {
        val manager = getSystemService(ConnectivityManager::class.java) ?: return false
        val network = manager.activeNetwork ?: return false
        val capabilities = manager.getNetworkCapabilities(network) ?: return false
        return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
    }

    private fun mapAuthorizationError(error: Exception): String =
        if (error is ApiException && error.statusCode == 16) "signedOut" else "unknownError"

    private fun encode(value: String): String =
        URLEncoder.encode(value, StandardCharsets.UTF_8.toString())
}

private class DriveRecoveryException(
    val code: String,
    override val message: String,
    val httpStatus: Int,
) : Exception(message)
