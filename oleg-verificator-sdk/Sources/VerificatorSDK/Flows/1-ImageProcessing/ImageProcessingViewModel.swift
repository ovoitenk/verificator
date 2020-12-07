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

class ImageProcessingViewModel<T: ImageProcessingServiceType>: ImageProcessingViewModelType {
    let image: Data
    let service: T
    let coordinator: CoordinatorType
    let configuration: VerificatorConfiguration
    weak var view: ImageProcessingViewType?
    var successCallback: ((T.Response) -> Void)?
    var failureCallback: ((T.ImageProcessingError) -> Void)?
    init(image: Data, service: T, coordinator: CoordinatorType, configuration: VerificatorConfiguration) {
        self.image = image
        self.service = service
        self.coordinator = coordinator
        self.configuration = configuration
    }
    
    private (set) var state: ImageProcessingState = .idle {
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
                case .success(response: let response):
                    self?.successCallback?(response)
                case .failure(error: let error):
                    guard let s = self else { return }
                    switch s.configuration.errorHandlingMode {
                    case .automatic:
                        self?.state = .error(message: error.localizedDescription, canRetry: true)
                    case .manual:
                        self?.failureCallback?(error)
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
