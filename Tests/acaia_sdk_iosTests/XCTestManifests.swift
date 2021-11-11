import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(acaia_sdk_iosTests.allTests),
    ]
}
#endif
