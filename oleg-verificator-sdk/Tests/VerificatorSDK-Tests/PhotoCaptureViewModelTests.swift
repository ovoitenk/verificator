import XCTest
@testable import VerificatorSDK

final class PhotoCaptureViewModelTests: XCTestCase {
    
    private class MockCoordinator: CoordinatorType {
        func navigate(to: CoordinatorEntry, animated: Bool) { }
    }
    
    func testConfiguration() {
        let confirutation = createDefaultConfiguration()
        let vm = PhotoCaptureViewModel(coordinator: MockCoordinator(), configuration: confirutation)
        XCTAssertTrue(confirutation.title == vm.title)
        XCTAssertTrue(confirutation.description == vm.description)
        XCTAssertTrue(confirutation.tintColor == vm.tintColor)
        XCTAssertTrue(confirutation.defaultCamera == vm.cameraType)
    }
    
    func testStateSwitch() {
        let confirutation = createDefaultConfiguration()
        let vm = PhotoCaptureViewModel(coordinator: MockCoordinator(), configuration: confirutation)
        switch vm.state {
        case .idle: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
        
        vm.startSession()
        switch vm.state {
        case .session: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
        
        vm.takePhoto()
        switch vm.state {
        case .photoCapturing: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
        
        vm.endSession()
        switch vm.state {
        case .idle: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
    }
    
    func testFlipCamera() {
        let confirutation = createDefaultConfiguration()
        let vm = PhotoCaptureViewModel(coordinator: MockCoordinator(), configuration: confirutation)
        vm.flipCamera()
        XCTAssertTrue(confirutation.defaultCamera.inverted == vm.cameraType)
    }
    
    private func createDefaultConfiguration() -> PhotoCaptureConfiguration {
        return PhotoCaptureConfiguration(
            title: "Title 21$",
            description: "Desc 314@",
            defaultCamera: .front,
            tintColor: .black,
            errorHandlingMode: .manual
        )
    }
    
    static var allTests = [
        ("testConfiguration", testConfiguration),
        ("testFlipCamera", testFlipCamera),
        ("testStateSwitch", testStateSwitch)
    ]
}
