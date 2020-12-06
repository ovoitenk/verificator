//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

protocol CoordinatorContext {
    var coordinator: CoordinatorType { get }
}

enum CoordinatorEntry {
    case capturePhoto
    case textRecognition(image: UIImage)
    case dismissal
}

protocol CoordinatorType: AnyObject {
    func navigate(to: CoordinatorEntry, animated: Bool)
}

class Coordinator: CoordinatorType {
    private let context: CommonContext
    init(context: CommonContext) {
        self.context = context
    }
    
    func navigate(to: CoordinatorEntry, animated: Bool) {
        switch to {
        case .capturePhoto:
            let viewModel = CardIdReaderViewModel(coordinator: self)
            let controller = CardIdReaderViewController(viewModel: viewModel)
            if let navigation = presentedNavigation {
                navigation.setViewControllers([controller], animated: animated)
            } else {
                let navigation = CommonNavigationController(rootViewController: controller)
                navigation.modalPresentationStyle = .fullScreen
                root?.present(navigation, animated: animated, completion: nil)
                presentedNavigation = navigation
            }
        case .textRecognition(image: let image):
            let viewModel = ImageProcessingViewModel(
                image: image,
                service: context.makeTextRecognitionService(),
                coordinator: self
            )
            let controller = ImageProcessingViewController(viewModel: viewModel)
            presentedNavigation?.setViewControllers([controller], animated: animated)
        case .dismissal:
            presentedNavigation?.dismiss(animated: true, completion: nil)
        }
    }
    
    private weak var presentedNavigation: UINavigationController?
    
    var root: UIViewController? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
    }
}
