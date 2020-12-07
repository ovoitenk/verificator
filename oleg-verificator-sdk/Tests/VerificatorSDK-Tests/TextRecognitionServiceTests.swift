import XCTest
@testable import VerificatorSDK

final class TextRecognitionServiceTests: XCTestCase {
    var service: TextRecognitionService {
        return TextRecognitionService(minConfidence: 0.6)
    }
    
    func testSingleString() {
        let entries = [TextRecognitionResultEntry(text: "test!@", confidence: 1.0)]
        let res = service.imageProcessingResult(from: entries)
        switch res {
        case .success(response: let response):
            XCTAssertTrue(response.count == 1)
            XCTAssertTrue(response[0] == entries[0].text)
        case .failure:
            XCTAssertTrue(false)
        }
    }
    
    func testNoData() {
        let res = service.imageProcessingResult(from: [])
        switch res {
        case .success:
            XCTAssertTrue(false)
        case .failure(error: let error):
            switch error {
            case .noData: XCTAssertTrue(true)
            default: XCTAssertTrue(false)
            }
        }
    }
    
    func testMixedStrings() {
        let entries = [
            TextRecognitionResultEntry(text: "test!@", confidence: 1.0),
            TextRecognitionResultEntry(text: "2341", confidence: 0.5),
            TextRecognitionResultEntry(text: "yoqerq", confidence: 0.3),
            TextRecognitionResultEntry(text: "ppopa", confidence: 0.6)
        ]
        let res = service.imageProcessingResult(from: entries)
        switch res {
        case .success(response: let response):
            XCTAssertTrue(response.count == 2)
            XCTAssertTrue(response[1] == "ppopa")
        case .failure:
            XCTAssertTrue(false)
        }
    }

    static var allTests = [
        ("testSingleString", testSingleString),
        ("testNoData", testNoData),
        ("testMixedStrings", testMixedStrings),
    ]
}
