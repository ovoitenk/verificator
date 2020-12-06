//
//  ViewController.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import UIKit
import VerificatorSDK

class MenuViewController: UIViewController {
    
    private var viewModel: MenuViewModelType = MenuViewModel()
    private var buttons: [UIButton] = []
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        title = viewModel.title
        view.backgroundColor = .darkGray
        buttons = viewModel.menu.map({ createButton(menuItem: $0) })
        buttons.forEach({ stackView.addArrangedSubview($0) })
        
        view.addSubview(stackView)
        configureStackView()
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: stackView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 32.0
            ),
            NSLayoutConstraint(
                item: stackView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -32
            ),
            NSLayoutConstraint(
                item: stackView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0
            ),
        ])
    }
    
    private func createButton(menuItem: MenuItemViewModelType) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(menuItem.text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(hexString: "B8E0DD")
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(hexString: "1E4D5D"), for: .normal)
        button.addTarget(self, action: #selector(buttonMenuTap(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: button,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 48
            )
        ])
        return button
    }
    
    @objc private func buttonMenuTap(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        viewModel.select(index: index)
    }
}

extension MenuViewController: MenuViewType {
    func showTexts(viewModel: TextsViewModelType) {
        let controller = TextsViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSelfieResult(confidence: Double) {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        let confidenceString = nf.string(from: NSNumber(value: confidence)) ?? ""
        let message = "Congrats! We are \(confidenceString)% sure about your face :)"
        let viewModel = MessageViewModel(title: "Successful Face", message: message)
        let controller = MessageViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
