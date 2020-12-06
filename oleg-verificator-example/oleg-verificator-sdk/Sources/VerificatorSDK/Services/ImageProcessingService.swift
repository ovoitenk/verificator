//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit
import Vision

enum ImageProcessingError: LocalizedError {
    case noCgImage
    case noData
    
    var errorDescription: String? {
        switch self {
        case .noCgImage:
            return "There is a problem with the image format."
        case .noData:
            return "No texts were found on the photo. Please try again."
        }
    }
}

enum ImageProcessingResult {
    case success(texts: [String])
    case failure(error: Error)
}

protocol ImageProcessingServiceType {
    func process(image: UIImage, minConfidence: Float, completion: @escaping (ImageProcessingResult) -> Void)
}

class ImageProcessingService: ImageProcessingServiceType {
    
    func process(image: UIImage, minConfidence: Float, completion: @escaping (ImageProcessingResult) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(error: ImageProcessingError.noCgImage))
            return
        }
        
        let requestHandler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: orientation(from: image.imageOrientation)
        )
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(error: ImageProcessingError.noData))
                return
            }
            let recognizedStrings = observations
                .compactMap({ $0.topCandidates(1).first })
                .filter({ $0.confidence >= minConfidence })
                .map({ $0.string })
            guard !recognizedStrings.isEmpty else {
                completion(.failure(error: ImageProcessingError.noData))
                return
            }
            completion(.success(texts: recognizedStrings))
        }

        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error: error))
        }

    }
    
    private func orientation(from: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch from {
        case .down:
            return .down
        case .downMirrored:
            return .downMirrored
        case .left:
            return .left
        case .leftMirrored:
            return .leftMirrored
        case .right:
            return .right
        case .rightMirrored:
            return .rightMirrored
        case .up:
            return .up
        case .upMirrored:
            return .upMirrored
        @unknown default:
            return .down
        }
    }
}
