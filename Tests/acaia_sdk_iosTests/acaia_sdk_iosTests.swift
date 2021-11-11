import XCTest
@testable import acaia_sdk_ios

final class acaia_sdk_iosTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(acaia_sdk_ios().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
