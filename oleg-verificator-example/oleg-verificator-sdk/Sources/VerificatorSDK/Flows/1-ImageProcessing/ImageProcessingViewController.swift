//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

class ImageProcessingViewController: UIViewController {
    private var viewModel: ImageProcessingViewModelType
    init(viewModel: ImageProcessingViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        self.viewModel.view = self
        self.viewModel.process()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorStyle.dark
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissTap(_:))
        )
        
        view.addSubview(mainStack)
        mainStack.layout([
            Constraint(.leading).constant(16),
            Constraint(.trailing).constant(16),
            Constraint(.centerY)
        ])
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = ColorStyle.white
        view.startAnimating()
        return view
    }()
    
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ColorStyle.white
        return label
    }()
    
    private lazy var buttonRetry: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonRetryTap(_:)), for: .touchUpInside)
        button.setTitleColor(ColorStyle.white, for: .normal)
        button.setTitle("Retry", for: .normal)
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [activityIndicator, labelDescription, buttonRetry])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    @objc private func buttonRetryTap(_ sender: UIButton) {
        viewModel.retry()
    }
    
    @objc private func dismissTap(_ sender: UIBarButtonItem) {
        viewModel.cancel()
    }
}

extension ImageProcessingViewController: ImageProcessingViewType {
    func update(state: ImageProcessingState) {
        switch state {
        case .idle:
            labelDescription.isHidden = true
            activityIndicator.isHidden = true
            buttonRetry.isHidden = true
        case .loading:
            labelDescription.text = "Processing image..."
            labelDescription.isHidden = false
            activityIndicator.isHidden = false
            buttonRetry.isHidden = true
        case .error(message: let message, canRetry: let retry):
            labelDescription.text = message
            labelDescription.isHidden = false
            activityIndicator.isHidden = true
            buttonRetry.isHidden = !retry
        }
    }
}
