import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(oleg_verificator_sdkTests.allTests),
    ]
}
#endif
