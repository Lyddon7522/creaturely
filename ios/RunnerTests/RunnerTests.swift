import Flutter
import UIKit
import XCTest

@testable import Runner

class RunnerTests: XCTestCase {
  func testCreaturelyApplicationIdentity() {
    let applicationBundle = Bundle(for: AppDelegate.self)
    XCTAssertEqual(applicationBundle.bundleIdentifier, "com.vector42.creaturely")
    XCTAssertEqual(
      applicationBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String,
      "Creaturely"
    )
  }
}
