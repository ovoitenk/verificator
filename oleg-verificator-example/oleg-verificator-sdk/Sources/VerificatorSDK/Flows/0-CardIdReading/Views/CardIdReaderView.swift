//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

class CardIdReaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelDescription, buttonsView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    let labelDescription: UILabel = {
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
    
    private func setup() {
        addSubview(bottomStack)
        bottomStack.layout([
            Constraint(.leading).constant(16),
            Constraint(.trailing).constant(16),
            Constraint(.bottom).to(safeAreaLayoutGuide)
        ])
        
        addSubview(cameraView)
        cameraView.layout([
            Constraint(.leading),
            Constraint(.top).to(safeAreaLayoutGuide),
            Constraint(.trailing),
            Constraint(.bottom).to(bottomStack, attribute: .top).constant(16)
        ])
    }
}
