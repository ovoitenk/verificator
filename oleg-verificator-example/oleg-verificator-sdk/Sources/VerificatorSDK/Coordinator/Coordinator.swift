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
    case completion(texts: [String])
    case failure(error: VerificatorError)
}

protocol CoordinatorType: AnyObject {
    func navigate(to: CoordinatorEntry, animated: Bool)
}

class Coordinator: CoordinatorType {
    enum Mode {
        case cardId(callback: ((VerificatorStatus<[String]>) -> Void))
        case selfie(callback: ((VerificatorStatus<Bool>) -> Void))
    }
    
    private let context: CommonContext
    private let mode: Mode
    private var configuration: VerificatorConfiguration { return context.configuration }
    init(context: CommonContext, mode: Mode) {
        self.context = context
        self.mode = mode
    }
    
    func navigate(to: CoordinatorEntry, animated: Bool) {
        switch to {
        case .capturePhoto:
            let configuration: PhotoCaptureConfiguration
            switch mode {
            case .cardId:
                configuration = createCardIdConfiguration()
            case .selfie:
                configuration = createSelfieConfiguration()
            }
            let viewModel = PhotoCaptureViewModel(
                coordinator: self,
                configuration: configuration
            )
            let controller = CardIdReaderViewController(viewModel: viewModel)
            if let navigation = presentedNavigation {
                navigation.setViewControllers([controller], animated: animated)
            } else {
                let navigation = CommonNavigationController(rootViewController: controller, tintColor: configuration.tintColor)
                navigation.modalPresentationStyle = .fullScreen
                root?.present(navigation, animated: animated, completion: nil)
                presentedNavigation = navigation
            }
        case .textRecognition(image: let image):
            let viewModel = ImageProcessingViewModel(
                image: image,
                service: context.makeTextRecognitionService(),
                coordinator: self,
                configuration: configuration
            )
            let controller = ImageProcessingViewController(viewModel: viewModel)
            presentedNavigation?.setViewControllers([controller], animated: animated)
        case .dismissal:
            presentedNavigation?.dismiss(animated: true, completion: nil)
            callbcakCancellation()
        case .completion(texts: let texts):
            switch mode {
            case .cardId(callback: let callback):
                presentedNavigation?.dismiss(animated: true, completion: nil)
                callback(.done(texts))
            case .selfie:
                print("Expected callback doesn't match the received response.")
            }
        case .failure(error: let error):
            presentedNavigation?.dismiss(animated: true, completion: nil)
            callbcakError(error: error)
        }
    }
    
    private weak var presentedNavigation: UINavigationController?
    
    var root: UIViewController? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
    }
    
    private func callbcakCancellation() {
        switch mode {
        case .cardId(callback: let callback):
            callback(.cancelled)
        case .selfie(callback: let callback):
            callback(.cancelled)
        }
    }
    
    private func callbcakError(error: VerificatorError) {
        switch mode {
        case .cardId(callback: let callback):
            callback(.error(error))
        case .selfie(callback: let callback):
            callback(.error(error))
        }
    }
    
    private func createCardIdConfiguration() -> PhotoCaptureConfiguration {
        return PhotoCaptureConfiguration(
            title: "Card ID",
            description: "Make sure your ID is clear and readable.",
            defaultCamera: .back,
            tintColor: configuration.tintColor,
            errorHandlingMode: configuration.errorHandlingMode
        )
    }
    
    private func createSelfieConfiguration() -> PhotoCaptureConfiguration {
        return PhotoCaptureConfiguration(
            title: "Selfie",
            description: "Make sure your face is completely inside the frame.",
            defaultCamera: .front,
            tintColor: configuration.tintColor,
            errorHandlingMode: configuration.errorHandlingMode
        )
    }
}
