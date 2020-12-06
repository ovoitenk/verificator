//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

class CommonContext: TextRecognitionServiceMakerContext {
    let configuration: VerificatorConfiguration
    init(configuration: VerificatorConfiguration) {
        self.configuration = configuration
    }
    
    func makeTextRecognitionService() -> ImageProcessingServiceType {
        return TextRecognitionService(minConfidence: configuration.textRecognitionMinConfidence)
    }
}

protocol TextRecognitionServiceMakerContext {
    func makeTextRecognitionService() -> ImageProcessingServiceType
}
