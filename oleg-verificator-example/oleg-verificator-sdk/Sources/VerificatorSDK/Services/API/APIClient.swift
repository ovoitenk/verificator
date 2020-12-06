//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

class APIClient {
    
    /**
    * Listed some errors that may be encountered
    */
    enum APIRequestError: Error {
        case invalidRequest
        case invalidResponse
    }
    
    /**
    * Callback
    */
    typealias ResultCallback<T> = (Result<T>) -> Void
    
    /**
    * Return data type
    */
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    private (set) var baseUrl: URL
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    /**
    * Allows dynamically update base URL in case of change
    */
    func updateBaseUrl(_ url: URL) {
        self.baseUrl = url
    }
    
    /**
     * Sends a request to the API
     * - Parameter request: A request that will be sent to the API
     * - Parameter callback: A callback that will be called in the main queue once the response has been processed
     */
    @discardableResult
    func sendRequest<T: Encodable, U: Decodable>(_ request: NetworkRequest<T>, callback: @escaping ResultCallback<U>) -> URLSessionDataTask? {
        guard let urlRequest = createUrlRequest(from: request) else {
            callback(.failure(APIRequestError.invalidRequest))
            return nil
        }
        log(request: urlRequest)
        // Send the request
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let s = self else { return }
            s.log(response: response, data: data, error: error)
            s.handleResponse(
                request: request,
                data: data,
                response: response,
                error: error,
                callback: callback
            )
        }
        dataTask.resume()
        return dataTask
    }
    
    /**
     * Handles the Network response
     * - Parameter request: The original request
     * - Parameter data: The data that may have been received
     * - Parameter response: The response that may have been received
     * - Parameter error: The error that may have been received
     * - Returns: An observable that will be called once the response has been handled
     */
    private func handleResponse<T: Encodable, U: Decodable>(
        request: NetworkRequest<T>,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        callback: ResultCallback<U>) {
        // Check if an error has been received
        if let err = error {
            guard (err as NSError).code != NSURLErrorCancelled else {
                // the request was cancelled by the user, forget about it
                return
            }
            callback(.failure(err))
            return
        }
        // Check if some data has been received and if the response is valid
        guard let data = data, let response = response as? HTTPURLResponse else {
            callback(.failure(APIRequestError.invalidResponse))
            return
        }
        // Check if the response contains an error
        if let error = NetworkError(status: response.statusCode, body: data) {
            callback(.failure(error))
            return
        }

        do {
            let responseObject = try request.decoder.decode(U.self, from: data)
            callback(.success(responseObject))
        } catch {
            callback(.failure(error))
        }
    }
    
    private func createUrlRequest<T: Encodable>(from request: NetworkRequest<T>) -> URLRequest? {
        do {
            guard var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(request.path), resolvingAgainstBaseURL: false) else {
                return nil
            }
            urlComponents.queryItems = request.queryItems
            guard let url = urlComponents.url else {
                return nil
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpMethod = request.method.rawValue
            if let params = request.parameters {
                urlRequest.httpBody = try JSONEncoder().encode(params)
            }
            return urlRequest
        } catch {
            print("Error while creating URL request:\n\(error)")
            return nil
        }
    }
}


// MARK: - Logs
extension APIClient {
    private func log(request: URLRequest) {
        log(requestBody: request.httpBody,
            httpMethod: request.httpMethod,
            url: request.url,
            headers: request.allHTTPHeaderFields)
    }
    
    private func log(requestBody: Data?, httpMethod: String?, url: URL?, headers: [String: String]?) {
        let bodyString = String(data: requestBody ?? Data(), encoding: .utf8)
        print("""
            Request: \(httpMethod ?? "") \(url?.absoluteString ?? "")
            Body: \(bodyString ?? "")
            Headers: \(headers ?? [:])
            """)
    }
    
    private func log(response: URLResponse?, data: Data?, error: Error?) {
        if let error = error {
            print("Response: \(error.localizedDescription)")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        log(url: response?.url, responseBody: data, statusCode: httpResponse.statusCode)
    }
    
    private func log(url: URL?, responseBody: Data?, statusCode: Int) {
        let bodyString = String(data: responseBody ?? Data(), encoding: .utf8) ?? String(data: responseBody ?? Data(), encoding: .ascii)
        print("""
            URL: \(String(describing: url?.absoluteString)) Response: \(statusCode)
            Body: \(bodyString ?? "")
            """)
    }
}
