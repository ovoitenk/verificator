//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

class CommonContext {
    let configuration: VerificatorConfiguration
    init(configuration: VerificatorConfiguration) {
        self.configuration = configuration
    }
    
    func makeTextRecognitionService() -> ImageProcessingServiceType {
        return TextRecognitionService(minConfidence: configuration.textRecognitionMinConfidence)
    }
    
    func makeSelfieDetectionService() -> ImageProcessingServiceType {
        return SelfieDetectionService()
    }
}
