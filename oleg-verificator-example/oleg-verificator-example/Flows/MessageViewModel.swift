//
//  MessageViewModel.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation

protocol MessageViewModelType {
    var title: String { get }
    var message: String { get }
}

class MessageViewModel: MessageViewModelType {
    let message: String
    let title: String
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
