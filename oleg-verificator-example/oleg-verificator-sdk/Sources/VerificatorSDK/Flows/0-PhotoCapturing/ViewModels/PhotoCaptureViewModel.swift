//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

enum PhotoCaptureError: LocalizedError {
    case noCameraAccess
    case noCameraDevice
    case system(message: String)
    
    var errorDescription: String? {
        switch self {
        case .noCameraAccess:
            return "Verificator doesn't have access to the camera. Please change privacy settings."
        case .noCameraDevice:
            return "Verificator is having troubles with detecting your camera. Please make sure it is installed."
        case .system(message: let message):
            return message
        }
    }
}

enum PhotoCaptureState {
    case idle
    case session(cameraType: PhotoCaptureCameraType)
    case failure(message: String)
    case photoCapturing
}

enum PhotoCaptureCameraType {
    case back
    case front
    
    var inverted: PhotoCaptureCameraType {
        switch self {
        case .back: return .front
        case .front: return .back
        }
    }
}

protocol PhotoCaptureViewType: AnyObject {
    func update(state: PhotoCaptureState)
}

protocol PhotoCaptureViewModelType {
    var title: String { get }
    var description: String { get }
    var view: PhotoCaptureViewType? { get set }
    var state: PhotoCaptureState { get }
    var tintColor: UIColor { get }
    
    func startSession()
    func endSession()
    func takePhoto()
    func flipCamera()
    func cancel()
    func processPhoto(image: Data)
    func reportError(_ error: PhotoCaptureError)
}

class PhotoCaptureViewModel: PhotoCaptureViewModelType {
    var title: String {
        return configuration.title
    }
    
    var description: String {
        return configuration.description
    }
    
    weak var view: PhotoCaptureViewType?
    private (set) var cameraType: PhotoCaptureCameraType
    
    private (set) var state: PhotoCaptureState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                s.view?.update(state: s.state)
            }
        }
    }
    
    var tintColor: UIColor { configuration.tintColor }
    
    private let coordinator: CoordinatorType
    private let configuration: PhotoCaptureConfiguration
    init(coordinator: CoordinatorType, configuration: PhotoCaptureConfiguration) {
        self.coordinator = coordinator
        self.configuration = configuration
        self.cameraType = configuration.defaultCamera
    }
    
    func startSession() {
        state = .session(cameraType: cameraType)
    }
    
    func endSession() {
        state = .idle
    }
    
    func takePhoto() {
        state = .photoCapturing
    }
    
    func flipCamera() {
        cameraType = cameraType.inverted
        state = .session(cameraType: cameraType)
    }
    
    func cancel() {
        coordinator.navigate(to: .dismissal, animated: true)
    }
    
    func reportError(_ error: PhotoCaptureError) {
        switch configuration.errorHandlingMode {
        case .automatic:
            state = .failure(message: error.localizedDescription)
        case .manual:
            coordinator.navigate(
                to: .failure(error: VerificatorError(error: error)),
                animated: true
            )
        }
    }
    
    func processPhoto(image: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.coordinator.navigate(to: .textRecognition(image: image), animated: true)
        }
    }
}
