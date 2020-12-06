//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

protocol ImageProcessingViewType: AnyObject {
    func update(state: ImageProcessingState)
}

protocol ImageProcessingViewModelType {
    var view: ImageProcessingViewType? { get set }
    var title: String { get }
    var tintColor: UIColor { get }
    
    func process()
    func retry()
    func cancel()
}

enum ImageProcessingState {
    case idle
    case loading
    case error(message: String, canRetry: Bool)
}

class ImageProcessingViewModel: ImageProcessingViewModelType {
    let image: UIImage
    let service: ImageProcessingServiceType
    let coordinator: Coordinator
    let configuration: VerificatorConfiguration
    weak var view: ImageProcessingViewType?
    init(image: UIImage, service: ImageProcessingServiceType, coordinator: Coordinator, configuration: VerificatorConfiguration) {
        self.image = image
        self.service = service
        self.coordinator = coordinator
        self.configuration = configuration
    }
    
    private var state: ImageProcessingState = .idle {
        didSet {
            view?.update(state: state)
        }
    }
    
    var title: String {
        return "Processing"
    }
    
    var tintColor: UIColor {
        return configuration.tintColor
    }
    
    func process() {
        state = .loading
        service.process(image: image) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(texts: let texts):
                    self?.coordinator.navigate(to: .completion(texts: texts), animated: true)
                case .failure(error: let error):
                    guard let s = self else { return }
                    switch s.configuration.errorHandlingMode {
                    case .automatic:
                        self?.state = .error(message: error.localizedDescription, canRetry: true)
                    case .manual:
                        self?.coordinator.navigate(
                            to: .failure(error: VerificatorError(error: error)),
                            animated: true
                        )
                    }
                }
            }
        }
    }
    
    func retry() {
        coordinator.navigate(to: .capturePhoto, animated: true)
    }
    
    func cancel() {
        coordinator.navigate(to: .dismissal, animated: true)
    }
}
