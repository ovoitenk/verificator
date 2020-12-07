//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

/**
 Generic result of image processing
 */
enum ImageProcessingResult<T, U: LocalizedError> {
    case success(response: T)
    case failure(error: U)
}

/**
 Generic protocol for image processing service. Up to owner to resolve Response type and specific Error type
 */
protocol ImageProcessingServiceType {
    associatedtype Response
    associatedtype ImageProcessingError: LocalizedError
    func process(image: Data, completion: @escaping (ImageProcessingResult<Response, ImageProcessingError>) -> Void)
}
