import XCTest
@testable import VerificatorSDK

final class SelfieDetectionIntegrationTests: XCTestCase {
    
    private class SuccessSelfieDetectionService: SelfieDetectionService {
        private let faces: [SelfieDetectionFaceAnnotation]
        init(faces: [SelfieDetectionFaceAnnotation]) {
            self.faces = faces
            super.init(minConfidence: 0.6)
        }
        override func detectFaces(base64: String, callback: @escaping APIClient.ResultCallback<SelfieDetectionResponse>) {
            let response = SelfieDetectionResponse(responses: [
                SelfieDetectionResponse.Response(faceAnnotations: faces)
            ])
            callback(.success(response))
        }
    }
    
    private class FailureSelfieDetectionService: SelfieDetectionService {
        private let error: Error
        init(error: Error) {
            self.error = error
            super.init(minConfidence: 0.6)
        }
        override func detectFaces(base64: String, callback: @escaping APIClient.ResultCallback<SelfieDetectionResponse>) {
            callback(.failure(error))
        }
    }
    
    private class MockCoordinator: CoordinatorType {
        func navigate(to: CoordinatorEntry, animated: Bool) { }
    }
    
    func testIntegrationSuccess() {
        let configuration = VerificatorConfiguration(tintColor: .blue, errorHandlingMode: .automatic)
        let vm = ImageProcessingViewModel(
            image: Data(),
            service: SuccessSelfieDetectionService(faces: [.init(detectionConfidence: 0.75)]),
            coordinator: MockCoordinator(),
            configuration: configuration
        )
        let expectation = self.expectation(description: "processing")
        var succesConfidence: Double?
        var error: SelfieDetectionError?
        vm.successCallback = {
            succesConfidence = $0
            expectation.fulfill()
        }
        vm.failureCallback = {
            error = $0
            expectation.fulfill()
        }
        vm.process()
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssertNotNil(succesConfidence)
        XCTAssertTrue(succesConfidence == 0.75)
        XCTAssertNil(error)
    }
    
    func testIntegrationFailure() {
        let configuration = VerificatorConfiguration(tintColor: .blue, errorHandlingMode: .manual)
        let vm = ImageProcessingViewModel(
            image: Data(),
            service: FailureSelfieDetectionService(error: SelfieDetectionError.faceIsNotUnique),
            coordinator: MockCoordinator(),
            configuration: configuration
        )
        let expectation = self.expectation(description: "processing")
        var succesConfidence: Double?
        var error: SelfieDetectionError?
        vm.successCallback = {
            succesConfidence = $0
            expectation.fulfill()
        }
        vm.failureCallback = {
            error = $0
            expectation.fulfill()
        }
        vm.process()
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssertNil(succesConfidence)
        XCTAssertNotNil(error)
        error.map({
            switch $0 {
            case .network: XCTAssertTrue(true)
            default: XCTAssertTrue(false)
            }
        })
    }
    
    static var allTests = [
        ("testIntegrationSuccess", testIntegrationSuccess),
        ("testIntegrationFailure", testIntegrationFailure)
    ]
}
