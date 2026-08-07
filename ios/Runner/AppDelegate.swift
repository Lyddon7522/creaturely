import CloudKit
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var recoveryBridge: CloudKitRecoveryBridge?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    recoveryBridge = CloudKitRecoveryBridge(
      messenger: engineBridge.applicationRegistrar.messenger()
    )
  }
}

/// Explicit, user-controlled recovery storage in the user's private CloudKit database.
///
/// Creaturely never reads or writes CloudKit during normal journal operation. The Dart
/// layer invokes this channel only after recovery has been enabled or when the user
/// explicitly selects a recovery action.
private final class CloudKitRecoveryBridge {
  private static let channelName = "com.vector42.creaturely/recovery"
  private static let recordType = "CreaturelyRecoverySnapshot"

  private let channel: FlutterMethodChannel
  private let container: CKContainer
  private let database: CKDatabase
  private let iso8601: ISO8601DateFormatter

  init(messenger: FlutterBinaryMessenger, container: CKContainer = .default()) {
    self.channel = FlutterMethodChannel(
      name: Self.channelName,
      binaryMessenger: messenger
    )
    self.container = container
    self.database = container.privateCloudDatabase
    self.iso8601 = ISO8601DateFormatter()
    self.iso8601.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(
          FlutterError(
            code: "unknownError",
            message: "Cloud recovery bridge is unavailable.",
            details: nil
          )
        )
        return
      }
      self.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "status", "authorize":
      accountStatus(result)
    case "upload":
      upload(arguments: call.arguments, result: result)
    case "list":
      list(result)
    case "download":
      download(arguments: call.arguments, result: result)
    case "delete":
      delete(arguments: call.arguments, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func accountStatus(_ result: @escaping FlutterResult) {
    container.accountStatus { status, error in
      if let error {
        self.fail(error, result: result)
        return
      }
      let value: String
      switch status {
      case .available:
        value = "available"
      case .noAccount:
        value = "signedOut"
      case .restricted:
        value = "permissionDenied"
      case .couldNotDetermine:
        value = "unknownError"
      @unknown default:
        value = "unknownError"
      }
      self.finish(result, value)
    }
  }

  private func upload(arguments: Any?, result: @escaping FlutterResult) {
    guard
      let values = arguments as? [String: Any],
      let id = values["id"] as? String,
      let typedBytes = values["bytes"] as? FlutterStandardTypedData,
      let createdAtValue = values["createdAt"] as? String,
      let createdAt = iso8601.date(from: createdAtValue)
    else {
      invalidArguments(result)
      return
    }

    let temporaryURL = FileManager.default.temporaryDirectory
      .appendingPathComponent("creaturely-\(UUID().uuidString).creaturely")
    do {
      try typedBytes.data.write(to: temporaryURL, options: .atomic)
    } catch {
      fail(error, result: result)
      return
    }

    let recordID = CKRecord.ID(recordName: id)
    let record = CKRecord(recordType: Self.recordType, recordID: recordID)
    record["backup"] = CKAsset(fileURL: temporaryURL)
    record["createdAt"] = createdAt as CKRecordValue
    record["byteLength"] = NSNumber(value: typedBytes.data.count)

    database.save(record) { _, error in
      try? FileManager.default.removeItem(at: temporaryURL)
      if let error {
        self.fail(error, result: result)
      } else {
        self.finish(result, nil)
      }
    }
  }

  private func list(_ result: @escaping FlutterResult) {
    let query = CKQuery(recordType: Self.recordType, predicate: NSPredicate(value: true))
    query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    queryPage(query: query, cursor: nil, records: []) { records, error in
      if let error {
        self.fail(error, result: result)
        return
      }
      let values: [[String: Any]] = records.compactMap { record in
        guard let createdAt = record["createdAt"] as? Date else { return nil }
        let byteLength = (record["byteLength"] as? NSNumber)?.intValue ?? 0
        return [
          "id": record.recordID.recordName,
          "createdAt": self.iso8601.string(from: createdAt),
          "byteLength": byteLength,
        ]
      }
      self.finish(result, values)
    }
  }

  private func queryPage(
    query: CKQuery,
    cursor: CKQueryOperation.Cursor?,
    records: [CKRecord],
    completion: @escaping ([CKRecord], Error?) -> Void
  ) {
    var accumulated = records
    let operation = cursor.map(CKQueryOperation.init(cursor:)) ?? CKQueryOperation(query: query)
    operation.desiredKeys = ["createdAt", "byteLength"]
    operation.recordFetchedBlock = { record in
      accumulated.append(record)
    }
    operation.queryCompletionBlock = { nextCursor, error in
      if let error {
        completion([], error)
      } else if let nextCursor {
        self.queryPage(
          query: query,
          cursor: nextCursor,
          records: accumulated,
          completion: completion
        )
      } else {
        completion(accumulated, nil)
      }
    }
    database.add(operation)
  }

  private func download(arguments: Any?, result: @escaping FlutterResult) {
    guard
      let values = arguments as? [String: Any],
      let id = values["id"] as? String
    else {
      invalidArguments(result)
      return
    }
    database.fetch(withRecordID: CKRecord.ID(recordName: id)) { record, error in
      if let error {
        self.fail(error, result: result)
        return
      }
      guard
        let asset = record?["backup"] as? CKAsset,
        let fileURL = asset.fileURL
      else {
        self.finish(
          result,
          FlutterError(
            code: "unknownError",
            message: "The recovery snapshot has no readable archive.",
            details: nil
          )
        )
        return
      }
      do {
        let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
        self.finish(result, FlutterStandardTypedData(bytes: data))
      } catch {
        self.fail(error, result: result)
      }
    }
  }

  private func delete(arguments: Any?, result: @escaping FlutterResult) {
    guard
      let values = arguments as? [String: Any],
      let id = values["id"] as? String
    else {
      invalidArguments(result)
      return
    }
    database.delete(withRecordID: CKRecord.ID(recordName: id)) { _, error in
      if let error {
        self.fail(error, result: result)
      } else {
        self.finish(result, nil)
      }
    }
  }

  private func invalidArguments(_ result: @escaping FlutterResult) {
    finish(
      result,
      FlutterError(
        code: "invalidArguments",
        message: "Cloud recovery received incomplete arguments.",
        details: nil
      )
    )
  }

  private func fail(_ error: Error, result: @escaping FlutterResult) {
    let state: String
    if let cloudError = error as? CKError {
      switch cloudError.code {
      case .notAuthenticated:
        state = "signedOut"
      case .networkUnavailable, .networkFailure, .serviceUnavailable, .requestRateLimited:
        state = "offline"
      case .quotaExceeded:
        state = "quotaExceeded"
      case .permissionFailure, .missingEntitlement:
        state = "permissionDenied"
      case .serverRecordChanged:
        state = "conflict"
      default:
        state = "unknownError"
      }
    } else {
      state = "unknownError"
    }
    finish(
      result,
      FlutterError(code: state, message: error.localizedDescription, details: nil)
    )
  }

  private func finish(_ result: @escaping FlutterResult, _ value: Any?) {
    DispatchQueue.main.async {
      result(value)
    }
  }
}
