//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

class CommonContext: TextRecognitionServiceMakerContext {
    init() {
    }
    
    func makeTextRecognitionService() -> ImageProcessingServiceType {
        return ImageProcessingService()
    }
}

protocol TextRecognitionServiceMakerContext {
    func makeTextRecognitionService() -> ImageProcessingServiceType
}
