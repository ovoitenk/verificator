import XCTest
@testable import VerificatorSDK

final class VerificatorSdkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Verificator.generateRandomNumber(), 4)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
