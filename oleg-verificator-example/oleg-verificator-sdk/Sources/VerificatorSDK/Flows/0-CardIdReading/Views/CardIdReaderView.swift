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
        stack.spacing = 16
        return stack
    }()
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = ColorStyle.white
        return label
    }()
    
    let labelError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ColorStyle.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonsView: UIView = {
        let view = UIView()
        view.layout([Constraint(.height).constant(72)])
        
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
    
    let cameraView: CameraPreviewView = {
        let view = CameraPreviewView()
        view.layer.cornerRadius = 16.0
        view.layer.masksToBounds = true
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
            Constraint(.bottom).to(safeAreaLayoutGuide).constant(16)
        ])
        
        addSubview(cameraView)
        cameraView.layout([
            Constraint(.leading),
            Constraint(.top).to(safeAreaLayoutGuide),
            Constraint(.trailing),
            Constraint(.bottom).to(bottomStack, attribute: .top).constant(16)
        ])
        
        addSubview(labelError)
        labelError.layout([
            Constraint(.leading).to(cameraView).constant(16),
            Constraint(.trailing).to(cameraView).constant(16),
            Constraint(.top).to(cameraView).constant(16),
            Constraint(.bottom).to(cameraView).constant(16)
        ])
    }
}
