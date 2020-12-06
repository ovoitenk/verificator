//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

class SelfieDetectionService: ImageProcessingServiceType {
    
    private let googleVisionApi: APIClient
    private let credentials: GoogleApiConfiguration
    init() {
        do {
            let googleConfig = try JSONReader().read(filename: "google_api_credentials", to: GoogleApiConfiguration.self)
            self.credentials = googleConfig
            self.googleVisionApi = APIClient(baseUrl: googleConfig.baseUrl)
        } catch {
            fatalError("Failed to read Google API credentials\n\(error)")
        }
    }
    
    func process(image: Data, completion: @escaping (ImageProcessingResult) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let base64 = image.base64EncodedString()
            self?.detectFaces(base64: base64, callback: { (result) in
                let t = ""
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
}
