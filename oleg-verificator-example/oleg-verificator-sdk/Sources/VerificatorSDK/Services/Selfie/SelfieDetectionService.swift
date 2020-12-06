//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

enum SelfieDetectionError: LocalizedError {
    case noFaces
    case faceIsNotUnique
    case network(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .noFaces:
            return "We can't detect any faces at the photo. Please try again."
        case .faceIsNotUnique:
            return "There are more than 1 face at the photo. Please retake."
        case .network(error: let error):
            return error.localizedDescription
        }
    }
}

class SelfieDetectionService: ImageProcessingServiceType {
    typealias Response = Double
    typealias ImageProcessingError = SelfieDetectionError
    
    
    private let googleVisionApi: APIClient
    private let credentials: GoogleApiConfiguration
    private let minConfidence: Float
    init(minConfidence: Float) {
        self.minConfidence = minConfidence
        do {
            let googleConfig = try JSONReader().read(filename: "google_api_credentials", to: GoogleApiConfiguration.self)
            self.credentials = googleConfig
            self.googleVisionApi = APIClient(baseUrl: googleConfig.baseUrl, logs: false)
        } catch {
            fatalError("Failed to read Google API credentials\n\(error)")
        }
    }
    
    func process(image: Data, completion: @escaping (ImageProcessingResult<Response, ImageProcessingError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let base64 = image.base64EncodedString()
            self?.detectFaces(base64: base64, callback: { (result) in
                switch result {
                case .success(let response):
                    self.map({ completion($0.imageProcessingResult(from: response)) })
                case .failure(let error):
                    completion(.failure(error: .network(error: error)))
                }
            })
        }
    }
    
    func detectFaces(base64: String, callback: @escaping APIClient.ResultCallback<SelfieDetectionResponse>) {
        var request: NetworkRequest<SelfieDetectionParams> = NetworkRequest(method: .post, path: "v1/images:annotate")
        request.queryItems = [URLQueryItem(name: "key", value: credentials.apiKey)]
        request.parameters = createFaceDetectionParams(base64: base64)
        googleVisionApi.sendRequest(request, callback: callback)
    }
    
    func createFaceDetectionParams(base64: String) -> SelfieDetectionParams {
        let feature = SelfieDetectionFeatureParam(maxResults: 5, type: "FACE_DETECTION")
        let request = SelfieDetectionParams.Request(
            image: SelfieDetectionImageParam(content: base64),
            features: [feature]
        )
        return SelfieDetectionParams(requests: [request])
    }
    
    func imageProcessingResult(from: SelfieDetectionResponse) -> ImageProcessingResult<Response, ImageProcessingError> {
        let faces = from.responses
            .flatMap({ $0.faceAnnotations ?? [] })
            .filter({ $0.detectionConfidence.map({ $0 > minConfidence }) ?? false })
        guard faces.count == 1 else {
            return faces.isEmpty ? .failure(error: .noFaces) : .failure(error: .faceIsNotUnique)
        }
        return .success(response: Double(faces[0].detectionConfidence ?? 0.0))
    }
}
