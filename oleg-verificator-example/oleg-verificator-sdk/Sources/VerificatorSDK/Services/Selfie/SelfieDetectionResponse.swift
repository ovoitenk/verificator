//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

struct SelfieDetectionResponse: Decodable {
    struct Response: Decodable {
        let faceAnnotations: [SelfieDetectionFaceAnnotation]?
    }
    
    let responses: [Response]
}

struct SelfieDetectionFaceAnnotation: Decodable {
    let detectionConfidence: Double?
}
