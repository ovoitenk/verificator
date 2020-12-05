//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation

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

protocol CardIdReaderViewModelType {
    var title: String { get }
    var description: String { get }
    
    func takePhoto()
    func flipCamera()
    func cancel()
    func reportError(_ error: CardIdReaderError)
}

class CardIdReaderViewModel: CardIdReaderViewModelType {
    
    var title: String {
        return "Card ID"
    }
    
    var description: String {
        return "Make sure your ID is clear and readable."
    }
    
    func takePhoto() {
        
    }
    
    func flipCamera() {
        
    }
    
    func cancel() {
        
    }
    
    func reportError(_ error: CardIdReaderError) {
        print("error: \(error.localizedDescription)")
    }
}
