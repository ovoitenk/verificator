//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit
import AVFoundation

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initiateSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        suspendSession()
        
        super.viewWillDisappear(animated)
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
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    private func initiateSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard granted else {
                    self?.viewModel.reportError(.noCameraAccess)
                    return
                }
                self?.setupCaptureSession()
            })
        default:
            viewModel.reportError(.noCameraAccess)
        }
    }
    
    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            viewModel.reportError(.noCameraDevice)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
                captureSession.addInput(input)
                captureSession.sessionPreset = .photo
                captureSession.addOutput(photoOutput)
                captureSession.commitConfiguration()
                setupLivePreview()
            } else {
                viewModel.reportError(.noCameraDevice)
            }
        } catch let error  {
            viewModel.reportError(.system(message: error.localizedDescription))
        }
    }
    
    private func setupLivePreview() {
        mainView.cameraView.session = captureSession
        mainView.cameraView.videoPreviewLayer.videoGravity = .resizeAspectFill
        mainView.cameraView.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func suspendSession() {
        captureSession.stopRunning()
    }
}
