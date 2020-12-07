//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

enum JSONReaderError: Error {
    case noData
}

class JSONReader {
    
    func read<T>(filename: String, to type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T where T : Decodable {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else {
            throw JSONReaderError.noData
        }
        let data = try Data(contentsOf: url)
        let object = try decoder.decode(T.self, from: data)
        return object
    }
}
