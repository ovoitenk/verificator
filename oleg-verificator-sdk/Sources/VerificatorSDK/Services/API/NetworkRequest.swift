//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

/**
 * List of all the error that might be in the api response
 */
struct NetworkError: Error {
    enum ErrorKind {
        case requestError
        case serverError
    }
    
    init?(status: Int, body: Data) {
        switch status {
        case 400...499:
            self.kind = .requestError
        case 500...599:
            self.kind = .serverError
        default:
            return nil
        }
        self.statusCode = status
        self.body = body
    }
    
    let kind: ErrorKind
    let statusCode: Int
    let body: Data
}

/**
 * Listed all the possible HTTP Methods
 */
enum NetworkRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct EmptyCodable: Codable {}
typealias VoidNetworkRequest = NetworkRequest<EmptyCodable>

struct NetworkRequest<T: Encodable> {
    
    init(method: NetworkRequestMethod, path: String, queryItems: [URLQueryItem]? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
    }
    
    /// The HTTP method
    var method: NetworkRequestMethod
    /// The HTTP headers
    var headers: [String : String]? = [
        "Content-Type": "application/json"
    ]
    /// The HTTP parameters
    var parameters: T?
    
    /// The url path
    var path: String
    
    /// The url query items
    var queryItems: [URLQueryItem]?
    
    /// Decoder to decode server response
    /// Provides default value as common decoder
    var decoder: JSONDecoder = JSONDecoder()
}
