//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

extension VerificatorError {
    init(error: TextRecognitionError) {
        switch error {
        case .noCgImage, .noData:
            self = .localError
        case .system:
            self = .unknown
        }
    }
    
    init(error: SelfieDetectionError) {
        switch error {
        case .network:
            self = .networkError
        case .noFaces:
            self = .faceRecognitionError(type: .noFace)
        case .faceIsNotUnique:
            self = .faceRecognitionError(type: .faceIsNotUnique)
        }
    }
    
    init(error: PhotoCaptureError) {
        switch error {
        case .noCameraAccess, .noCameraDevice:
            self = .cameraUnavailable
        case .system:
            self = .unknown
        }
    }
}
