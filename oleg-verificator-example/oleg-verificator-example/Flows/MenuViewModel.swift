//
//  MenuViewModel.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit
import VerificatorSDK

protocol MenuViewType: AnyObject {
    func showTexts(viewModel: TextsViewModelType)
}

protocol MenuViewModelType {
    var menu: [MenuItemViewModelType] { get }
    var title: String { get }
    var view: MenuViewType? { get set }
    
    func select(index: Int)
}

class MenuViewModel: MenuViewModelType {
    
    init() {
        self.menuItems = [
            MenuItemViewModel(item: .scanId, text: "SCAN ID CARD"),
            MenuItemViewModel(item: .selfie, text: "TAKE SELFIE")
        ]
    }
    
    let menuItems: [MenuItemViewModel]
    var menu: [MenuItemViewModelType] { return menuItems }
    var title: String { return "Menu" }
    weak var view: MenuViewType?
    
    func select(index: Int) {
        guard index >= 0 && index < menuItems.count else { return }
        switch menuItems[index].item {
        case .scanId:
            readCardId()
        case .selfie:
            makeSelfie()
        }
    }
    
    func readCardId() {
        Verificator.startCardIdReading { [weak self] (result) in
            switch result {
            case .done(let response):
                self?.view?.showTexts(viewModel: TextsViewModel(texts: response))
            case .cancelled:
                break
            case .error:
                // using Verificator with default automatic error hanling mode
                // errors are handed by the SDK itself
                break
            }
        }
    }
    
    func makeSelfie() {
        Verificator.startSelfieTaking { [weak self] (result) in
            switch result {
            case .done(let response):
                break
//                self?.view?.showTexts(viewModel: TextsViewModel(texts: response))
            case .cancelled:
                break
            case .error:
                // using Verificator with default automatic error hanling mode
                // errors are handed by the SDK itself
                break
            }
        }
    }
}

enum MenuItem {
    case scanId
    case selfie
}

protocol MenuItemViewModelType {
    var text: String { get }
}

struct MenuItemViewModel: MenuItemViewModelType {
    let item: MenuItem
    let text: String
}
