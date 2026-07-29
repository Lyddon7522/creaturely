import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use(keystoreProperties::load)
}

fun signingValue(propertyName: String, environmentName: String): String? {
    return keystoreProperties
        .getProperty(propertyName)
        ?.takeIf(String::isNotBlank)
        ?: System.getenv(environmentName)?.takeIf(String::isNotBlank)
}

val releaseStoreFile =
    signingValue("storeFile", "CREATURELY_ANDROID_KEYSTORE_PATH")
val releaseStorePassword =
    signingValue("storePassword", "CREATURELY_ANDROID_KEYSTORE_PASSWORD")
val releaseKeyAlias =
    signingValue("keyAlias", "CREATURELY_ANDROID_KEY_ALIAS")
val releaseKeyPassword =
    signingValue("keyPassword", "CREATURELY_ANDROID_KEY_PASSWORD")
val releaseSigningValues =
    listOf(
        releaseStoreFile,
        releaseStorePassword,
        releaseKeyAlias,
        releaseKeyPassword,
    )
val releaseSigningConfigured = releaseSigningValues.all { it != null }
val releaseSigningPartiallyConfigured = releaseSigningValues.any { it != null }
val releaseSigningRequired =
    System.getenv("CREATURELY_REQUIRE_RELEASE_SIGNING")
        ?.equals("true", ignoreCase = true) == true

check(!releaseSigningPartiallyConfigured || releaseSigningConfigured) {
    "Creaturely release signing is incomplete. Provide storeFile, " +
        "storePassword, keyAlias, and keyPassword in android/key.properties " +
        "or the CREATURELY_ANDROID_* environment variables."
}
check(!releaseSigningRequired || releaseSigningConfigured) {
    "Creaturely distribution builds require Android release-signing credentials."
}

android {
    namespace = "com.vector42.creaturely"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.vector42.creaturely"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (releaseSigningConfigured) {
            create("release") {
                storeFile = file(requireNotNull(releaseStoreFile))
                storePassword = requireNotNull(releaseStorePassword)
                keyAlias = requireNotNull(releaseKeyAlias)
                keyPassword = requireNotNull(releaseKeyPassword)
            }
        }
    }

    buildTypes {
        release {
            // Keep local release-mode runs convenient until a private
            // key.properties file is configured. CI sets
            // CREATURELY_REQUIRE_RELEASE_SIGNING=true, so a distribution build
            // can never silently fall back to the debug key.
            signingConfig =
                if (releaseSigningConfigured) {
                    signingConfigs.getByName("release")
                } else {
                    signingConfigs.getByName("debug")
                }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Google Identity Services is used only after the keeper explicitly opts in
    // to Android recovery snapshots in Drive's private appDataFolder.
    implementation("com.google.android.gms:play-services-auth:21.6.0")
}
