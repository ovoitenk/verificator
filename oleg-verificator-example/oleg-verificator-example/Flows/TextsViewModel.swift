//
//  TextsViewModel.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

protocol TextsViewModelType {
    var title: String { get }
    var texts: [String] { get }
}

class TextsViewModel: TextsViewModelType {
    let texts: [String]
    init(texts: [String]) {
        self.texts = texts
    }
    
    var title: String { return "Card Id Texts" }
}
