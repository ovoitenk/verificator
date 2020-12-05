//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

internal class CardIdReaderViewController: UIViewController {
    
    private let viewModel: CardIdReaderViewModelType
    init(viewModel: CardIdReaderViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissTap(_:))
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainView = CardIdReaderView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorStyle.dark
        
        title = viewModel.title
        mainView.labelDescription.text = viewModel.description
        mainView.buttonFlipCamera.addTarget(self, action: #selector(buttonFlipCameraTap(_:)), for: .touchUpInside)
        mainView.buttonTakePhoto.addTarget(self, action: #selector(buttonTakePhotoTap(_:)), for: .touchUpInside)
    }
    
    @objc private func dismissTap(_ sender: UIBarButtonItem) {
        viewModel.cancel()
    }
    
    @objc private func buttonFlipCameraTap(_ sender: UIButton) {
        viewModel.flipCamera()
    }
    
    @objc private func buttonTakePhotoTap(_ sender: UIButton) {
        viewModel.takePhoto()
    }
}
