import UIKit

public class Verificator {
    
    private static var configuration: VerificatorConfiguration?
    
    /**
     * Configures Verificator SDK.
     *  Optional method, SDK will use the default configuration
     * - Parameter configuration: An object with configuration data
     */
    public static func configure(configuration: VerificatorConfiguration) {
        Self.configuration = configuration
    }
    
    /**
     * Starts SDK for reading text from card ID
     *  Will present view controller on top of the active window.
     * - Parameter callback: A callback with SDK result. Returns an array with strings from the ID card for happy path.
     */
    public static func startCardIdReading(callback: @escaping (VerificatorStatus<[String]>) -> Void) {
        Coordinator(
            context: createCommonContext(),
            mode: .cardId(callback: callback)
        ).navigate(to: .capturePhoto, animated: true)
    }
    
    /**
     * Starts SDK for taking selfie and face verification
     *  Will present view controller on top of the active window.
     * - Parameter callback: A callback with SDK result. Returns a Double from 0.6 to 1 as a face confidence.
     */
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

/**
 * Result of SDK
 */
public enum VerificatorStatus<T> {
    case done(_ response: T)
    case cancelled
    case error(_ error: VerificatorError)
}

/**
 * List of possible error types which could be returned by the SDK
 */
public enum VerificatorError: Error {
    case cameraUnavailable
    case localError
    case networkError
    case faceRecognitionError(type: VerificatorFacesRecognitionErrorType)
    case unknown
}

/**
 * Face recognition error type
 */
public enum VerificatorFacesRecognitionErrorType {
    case noFace
    case faceIsNotUnique
}

/**
 * Configuration for the SDK.
 * - Parameter tintColor: Tint color for the active elements (aka buttons). Default #4FB1A9
 * - Parameter errorHandlingMode: Specifies error handling mode. Automatic by default.
 */
public struct VerificatorConfiguration {
    let tintColor: UIColor
    let errorHandlingMode: VeritificatorErrorHandlingMode
    
    // non overridable configuration property
    let minConfidence: Float = 0.6
    
    public init(tintColor: UIColor, errorHandlingMode: VeritificatorErrorHandlingMode) {
        self.tintColor = tintColor
        self.errorHandlingMode = errorHandlingMode
    }
}

/**
 * Error handling mode.
 * - Parameter automatic: SDK handles errors dispaly by itself and displays appropriate messages. VerificatorStatus.error is never called.
 * - Parameter manual: SDK invokes callback in case of an error. It is up to appliation to handle errors.
 */
public enum VeritificatorErrorHandlingMode {
    case automatic
    case manual
}
