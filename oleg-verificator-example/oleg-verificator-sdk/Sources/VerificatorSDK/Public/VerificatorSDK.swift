import UIKit

public class Verificator {
    
    private static var configuration: VerificatorConfiguration?
    
    public static func configure(configuration: VerificatorConfiguration) {
        Self.configuration = configuration
    }
    
    public static func startCardIdReading(callback: @escaping (VerificatorStatus<[String]>) -> Void) {
        Coordinator(
            context: createCommonContext(),
            mode: .cardId(callback: callback),
            configuration: configuration ?? createDefaultConfiguration()
        ).navigate(to: .capturePhoto, animated: true)
    }
    
    private static func createCommonContext() -> CommonContext {
        return CommonContext()
    }
    
    private static func createDefaultConfiguration() -> VerificatorConfiguration {
        return VerificatorConfiguration(
            tintColor: ColorStyle.tint,
            errorHandlingMode: .manual
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
    case unknown
}

public struct VerificatorConfiguration {
    let tintColor: UIColor
    let errorHandlingMode: VeritificatorErrorHandlingMode
}

public enum VeritificatorErrorHandlingMode {
    case automatic
    case manual
}
