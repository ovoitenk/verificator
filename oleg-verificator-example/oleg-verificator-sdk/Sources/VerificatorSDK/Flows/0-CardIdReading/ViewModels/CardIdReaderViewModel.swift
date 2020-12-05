//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation

protocol CardIdReaderViewModelType {
    var title: String { get }
    var description: String { get }
    
    func takePhoto()
    func flipCamera()
    func cancel()
}

class CardIdReaderViewModel: CardIdReaderViewModelType {
    
    var title: String {
        return "Card ID"
    }
    
    var description: String {
        return "Make sure your ID is clear and readable."
    }
    
    func takePhoto() {
        
    }
    
    func flipCamera() {
        
    }
    
    func cancel() {
        
    }
}
