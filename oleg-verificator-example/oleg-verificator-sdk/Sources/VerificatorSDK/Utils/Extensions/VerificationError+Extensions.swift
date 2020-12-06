//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

extension VerificatorError {
    init(error: ImageProcessingError) {
        switch error {
        case .noCgImage, .noData:
            self = .localError
        case .system:
            self = .unknown
        }
    }
    
    init(error: CardIdReaderError) {
        switch error {
        case .noCameraAccess, .noCameraDevice:
            self = .cameraUnavailable
        case .system:
            self = .unknown
        }
    }
}
