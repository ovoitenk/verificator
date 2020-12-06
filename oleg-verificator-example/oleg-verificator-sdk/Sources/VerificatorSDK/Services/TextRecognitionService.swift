//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit
import Vision

enum TextRecognitionError: LocalizedError {
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

class TextRecognitionService: ImageProcessingServiceType {
    typealias Response = [String]
    typealias ImageProcessingError = TextRecognitionError
    
    
    private let minConfidence: Float
    init(minConfidence: Float) {
        self.minConfidence = minConfidence
    }
    
    func process(image: Data, completion: @escaping (ImageProcessingResult<Response, ImageProcessingError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let s = self else { return }
            guard let uiImage = UIImage(data: image), let cgImage = uiImage.cgImage else {
                completion(.failure(error: ImageProcessingError.noCgImage))
                return
            }
            
            let requestHandler = VNImageRequestHandler(
                cgImage: cgImage,
                orientation: self?.orientation(from: uiImage.imageOrientation) ?? .down
            )
            
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    completion(.failure(error: ImageProcessingError.noData))
                    return
                }
                let recognizedStrings = observations
                    .compactMap({ $0.topCandidates(1).first })
                    .filter({ $0.confidence >= s.minConfidence })
                    .map({ $0.string })
                guard !recognizedStrings.isEmpty else {
                    completion(.failure(error: ImageProcessingError.noData))
                    return
                }
                completion(.success(response: recognizedStrings))
            }

            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error: .system(message: error.localizedDescription)))
            }

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
