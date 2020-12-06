import UIKit

public class Verificator {
    
    private static let coordinator: CoordinatorType = Coordinator()
    
    public static func startCardIdReading() {
        coordinator.navigate(to: .capturePhoto, animated: true)
    }
}
