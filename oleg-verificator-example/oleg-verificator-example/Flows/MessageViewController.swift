//
//  MessageViewController.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

class MessageViewController: UIViewController {
    private let viewModel: MessageViewModelType
    init(viewModel: MessageViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        title = viewModel.title
        view.backgroundColor = .gray
        labelMessage.text = viewModel.message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let labelMessage: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(labelMessage)
        configureLabel()
    }
    
    private func configureLabel() {
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: labelMessage,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 32.0
            ),
            NSLayoutConstraint(
                item: labelMessage,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -32
            ),
            NSLayoutConstraint(
                item: labelMessage,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0
            ),
        ])
    }
}
