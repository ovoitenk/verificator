import UIKit

public class Verificator {
    
    public static func startCardIdReading() {
        Coordinator(context: createCommonContext())
            .navigate(to: .capturePhoto, animated: true)
    }
    
    private static func createCommonContext() -> CommonContext {
        return CommonContext()
    }
}
