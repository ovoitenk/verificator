//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

enum ImageProcessingResult<T, U: LocalizedError> {
    case success(response: T)
    case failure(error: U)
}

protocol ImageProcessingServiceType {
    associatedtype Response
    associatedtype ImageProcessingError: LocalizedError
    func process(image: Data, completion: @escaping (ImageProcessingResult<Response, ImageProcessingError>) -> Void)
}

/*
protocol TestingImageProcessingServiceType {
    associatedtype Response
    associatedtype TestingError: Error
    func process(image: Data, completion: @escaping (TestingResult<Response, TestingError>) -> Void)
}

enum TestingResult<T, U: Error> {
    case success(response: T)
    case failure(error: U)
}

class TestClass: TestingImageProcessingServiceType {
    typealias TestingError = ImageProcessingError
    typealias Response = String
    
    func process(image: Data, completion: @escaping (TestingResult<Response, TestingError>) -> Void) {
        
    }
}
*/
