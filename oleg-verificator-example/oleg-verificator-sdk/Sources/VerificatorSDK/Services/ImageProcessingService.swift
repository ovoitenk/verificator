//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

enum ImageProcessingError: LocalizedError {
    case noCgImage
    case noData
    case system(message: String)
    
    var errorDescription: String? {
        switch self {
        case .noCgImage:
            return "There is a problem with the image format."
        case .noData:
            return "No texts were found on the photo. Please try again."
        case .system(message: let m):
            return m
        }
    }
}

enum ImageProcessingResult {
    case success(texts: [String])
    case failure(error: ImageProcessingError)
}

protocol ImageProcessingServiceType {
    func process(image: UIImage, completion: @escaping (ImageProcessingResult) -> Void)
}
