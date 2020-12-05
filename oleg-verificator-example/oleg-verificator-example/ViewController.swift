//
//  ViewController.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import UIKit
import VerificatorSDK

class ViewController: UIViewController {

    private lazy var buttonPresent: UIButton = {
        let button = UIButton()
        button.setTitle("Present", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonPresentTap(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonPresent)
        buttonPresent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: buttonPresent,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: buttonPresent,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0
            ),
        ])
    }

    @objc private func buttonPresentTap(_ sender: UIButton) {
        Verificator.startCardIdReading()
    }
}

