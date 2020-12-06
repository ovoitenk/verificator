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
    weak var view: ImageProcessingViewType?
    init(image: UIImage, service: ImageProcessingServiceType, coordinator: Coordinator) {
        self.image = image
        self.service = service
        self.coordinator = coordinator
    }
    
    private var state: ImageProcessingState = .idle {
        didSet {
            view?.update(state: state)
        }
    }
    
    var title: String {
        return "Processing"
    }
    
    func process() {
        state = .loading
        service.process(image: image, minConfidence: 0.6) { [weak self] (result) in
            switch result {
            case .success(texts: let texts):
                self?.coordinator.navigate(to: .dismissal, animated: true)
            case .failure(error: let error):
                self?.state = .error(message: error.localizedDescription, canRetry: true)
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
