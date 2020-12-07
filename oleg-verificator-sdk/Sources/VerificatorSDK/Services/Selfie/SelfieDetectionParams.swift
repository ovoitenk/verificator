//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

struct SelfieDetectionParams: Encodable {
    struct Request: Encodable {
        let image: SelfieDetectionImageParam
        let features: [SelfieDetectionFeatureParam]
    }
    
    let requests: [Request]
}


struct SelfieDetectionFeatureParam: Encodable {
    let maxResults: Int
    let type: String
}

struct SelfieDetectionImageParam: Encodable {
    let content: String
}
