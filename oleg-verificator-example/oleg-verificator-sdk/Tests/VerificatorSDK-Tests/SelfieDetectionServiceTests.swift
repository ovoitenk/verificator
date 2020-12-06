import XCTest
@testable import VerificatorSDK

final class SelfieDetectionServiceTests: XCTestCase {
    var service: SelfieDetectionService {
        return SelfieDetectionService(minConfidence: 0.6)
    }
    
    func testSingleFace() {
        let res = service.imageProcessingResult(from: createResponse(faces: [.init(detectionConfidence: 1.0)]))
        switch res {
        case .success(response: let value):
            XCTAssertTrue(value == 1.0)
        case .failure:
            XCTAssertTrue(false)
        }
    }
    
    func testNoFaces() {
        let res = service.imageProcessingResult(from: createResponse(faces: []))
        switch res {
        case .success:
            XCTAssertTrue(false)
        case .failure:
            XCTAssertTrue(true)
        }
    }
    
    func testTwoFaces() {
        let res = service.imageProcessingResult(
            from: createResponse(
                faces: [.init(detectionConfidence: 1.0), .init(detectionConfidence: 1.0)])
        )
        switch res {
        case .success:
            XCTAssertTrue(false)
        case .failure:
            XCTAssertTrue(true)
        }
    }
    
    func testBadConfidence() {
        let res = service.imageProcessingResult(from: createResponse(faces: [.init(detectionConfidence: 0.5)]))
        switch res {
        case .success:
            XCTAssertTrue(false)
        case .failure:
            XCTAssertTrue(true)
        }
    }
    
    func testMixedConfidence() {
        let res = service.imageProcessingResult(
            from: createResponse(
                faces: [.init(detectionConfidence: 0.5), .init(detectionConfidence: 1.0)])
        )
        switch res {
        case .success:
            XCTAssertTrue(true)
        case .failure:
            XCTAssertTrue(false)
        }
    }
    
    private func createResponse(faces: [SelfieDetectionFaceAnnotation]) -> SelfieDetectionResponse {
        return SelfieDetectionResponse(responses: [
            SelfieDetectionResponse.Response(faceAnnotations: faces)
        ])
    }

    static var allTests = [
        ("testSingleFace", testSingleFace),
        ("testNoFaces", testNoFaces),
        ("testTwoFaces", testTwoFaces),
        ("testBadConfidence", testBadConfidence),
        ("testMixedConfidence", testMixedConfidence)
    ]
}
