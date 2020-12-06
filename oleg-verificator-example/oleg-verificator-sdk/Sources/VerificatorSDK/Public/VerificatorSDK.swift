import UIKit

public class Verificator {
    
    private static var configuration: VerificatorConfiguration?
    
    public static func configure(configuration: VerificatorConfiguration) {
        Self.configuration = configuration
    }
    
    public static func startCardIdReading(callback: @escaping (VerificatorStatus<[String]>) -> Void) {
        Coordinator(
            context: createCommonContext(),
            mode: .cardId(callback: callback)
        ).navigate(to: .capturePhoto, animated: true)
    }
    
    public static func startSelfieTaking(callback: @escaping (VerificatorStatus<Double>) -> Void) {
        Coordinator(
            context: createCommonContext(),
            mode: .selfie(callback: callback)
        ).navigate(to: .capturePhoto, animated: true)
    }
    
    private static func createCommonContext() -> CommonContext {
        return CommonContext(configuration: configuration ?? createDefaultConfiguration())
    }
    
    private static func createDefaultConfiguration() -> VerificatorConfiguration {
        return VerificatorConfiguration(
            tintColor: ColorStyle.tint,
            errorHandlingMode: .automatic
        )
    }
}

public enum VerificatorStatus<T> {
    case done(_ response: T)
    case cancelled
    case error(_ error: VerificatorError)
}

public enum VerificatorError: Error {
    case cameraUnavailable
    case localError
    case networkError
    case faceRecognitionError(type: VerificatorFacesRecognitionErrorType)
    case unknown
}

public enum VerificatorFacesRecognitionErrorType {
    case noFace
    case faceIsNotUnique
}

public struct VerificatorConfiguration {
    let tintColor: UIColor
    let errorHandlingMode: VeritificatorErrorHandlingMode
    
    // non overridable configuration property
    let minConfidence: Float = 0.6
    
    init(tintColor: UIColor, errorHandlingMode: VeritificatorErrorHandlingMode) {
        self.tintColor = tintColor
        self.errorHandlingMode = errorHandlingMode
    }
}

public enum VeritificatorErrorHandlingMode {
    case automatic
    case manual
}
