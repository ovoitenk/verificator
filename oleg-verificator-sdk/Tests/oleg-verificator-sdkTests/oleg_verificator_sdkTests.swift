import XCTest
@testable import oleg_verificator_sdk

final class oleg_verificator_sdkTests: XCTestCase {
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
