//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

enum CardIdReaderError: LocalizedError {
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

enum CardIdReaderState {
    case idle
    case session(cameraType: CardIdReaderCameraType)
    case failure(message: String)
    case photoCapturing
}

enum CardIdReaderCameraType {
    case back
    case front
    
    var inverted: CardIdReaderCameraType {
        switch self {
        case .back: return .front
        case .front: return .back
        }
    }
}

protocol CardIdReaderViewType: AnyObject {
    func update(state: CardIdReaderState)
}

protocol CardIdReaderViewModelType {
    var title: String { get }
    var description: String { get }
    var view: CardIdReaderViewType? { get set }
    var state: CardIdReaderState { get }
    
    func startSession()
    func endSession()
    func takePhoto()
    func flipCamera()
    func cancel()
    func processPhoto(image: UIImage)
    func reportError(_ error: CardIdReaderError)
}

class CardIdReaderViewModel: CardIdReaderViewModelType {
    var title: String {
        return "Card ID"
    }
    
    var description: String {
        return "Make sure your ID is clear and readable."
    }
    
    weak var view: CardIdReaderViewType?
    private var cameraType: CardIdReaderCameraType = .back
    
    private (set) var state: CardIdReaderState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                s.view?.update(state: s.state)
            }
        }
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
        // TODO
    }
    
    func reportError(_ error: CardIdReaderError) {
        state = .failure(message: error.localizedDescription)
    }
    
    func processPhoto(image: UIImage) {
        // TODO 
    }
}
