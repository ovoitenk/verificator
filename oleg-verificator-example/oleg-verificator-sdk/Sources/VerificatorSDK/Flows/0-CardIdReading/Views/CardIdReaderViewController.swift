//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

internal class CardIdReaderViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissTap(_:))
        )
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorStyle.dark
        
        title = "Card ID"
    }
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelDescription, buttonsView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Testing test"
        label.textColor = ColorStyle.white
        return label
    }()
    
    private lazy var buttonsView: UIView = {
        let view = UIView()
        view.layout([Constraint(.height).constant(80)])
        
        view.addSubview(buttonTakePhoto)
        buttonTakePhoto.layout([
            .init(.centerX), .init(.top), .init(.bottom)
        ])
        
        let flipContainer = UIView()
        view.addSubview(flipContainer)
        flipContainer.layout([
            Constraint(.leading).to(buttonTakePhoto, attribute: .trailing),
            Constraint(.trailing),
            Constraint(.bottom),
            Constraint(.top)
        ])
        
        flipContainer.addSubview(buttonFlipCamera)
        buttonFlipCamera.layout([.init(.centerX), .init(.centerY)])
        return view
    }()
    
    let cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 16.0
        return view
    }()
    
    let buttonTakePhoto: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "take_photo", in: .module, with: nil), for: .normal)
        button.tintColor = ColorStyle.tintLight
        return button
    }()
    
    let buttonFlipCamera: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "flip_photo", in: .module, with: nil), for: .normal)
        button.tintColor = ColorStyle.tintLight
        button.layout([
            Constraint.init(.width).constant(44),
            Constraint.init(.height).constant(44)
        ])
        return button
    }()
    
    private func configure() {
        view.addSubview(bottomStack)
        bottomStack.layout([
            Constraint(.leading).constant(16),
            Constraint(.trailing).constant(16),
            Constraint(.bottom).to(view.safeAreaLayoutGuide)
        ])
        
        view.addSubview(cameraView)
        cameraView.layout([
            Constraint(.leading),
            Constraint(.top).to(view.safeAreaLayoutGuide),
            Constraint(.trailing),
            Constraint(.bottom).to(bottomStack, attribute: .top).constant(16)
        ])
    }
    
    @objc private func dismissTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
