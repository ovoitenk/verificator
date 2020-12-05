import UIKit

public class Verificator {
    
    public static func startCardIdReading() {
        guard let root = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController else { return }
        let controller = CardIdReaderViewController()
        let navigation = CommonNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        root.present(navigation, animated: true, completion: nil)
    }
    
    public static func generateRandomNumber() -> Int {
        return 4
    }
}
