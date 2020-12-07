import XCTest
@testable import VerificatorSDK

final class ImageProcessingViewModelTests: XCTestCase {
    
    private enum MockError: LocalizedError {
        
    }
    
    private class MockImageProcessingService: ImageProcessingServiceType {
        typealias Response = Bool
        typealias ImageProcessingError = MockError
        
        func process(image: Data, completion: @escaping (ImageProcessingResult<Bool, ImageProcessingViewModelTests.MockError>) -> Void) { }
    }
    
    private class MockCoordinator: CoordinatorType {
        func navigate(to: CoordinatorEntry, animated: Bool) { }
    }
    
    func testConfiguration() {
        let configuration = VerificatorConfiguration(tintColor: .blue, errorHandlingMode: .automatic)
        let vm = ImageProcessingViewModel(
            image: Data(),
            service: MockImageProcessingService(),
            coordinator: MockCoordinator(),
            configuration: configuration
        )
        XCTAssertTrue(configuration.tintColor == vm.tintColor)
    }
    
    func testSwitchState() {
        let configuration = VerificatorConfiguration(tintColor: .blue, errorHandlingMode: .automatic)
        let vm = ImageProcessingViewModel(
            image: Data(),
            service: MockImageProcessingService(),
            coordinator: MockCoordinator(),
            configuration: configuration
        )
        switch vm.state {
        case .idle: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
        
        vm.process()
        switch vm.state {
        case .loading: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
    }
    
    static var allTests = [
        ("testConfiguration", testConfiguration),
        ("testSwitchState", testSwitchState)
    ]
}
