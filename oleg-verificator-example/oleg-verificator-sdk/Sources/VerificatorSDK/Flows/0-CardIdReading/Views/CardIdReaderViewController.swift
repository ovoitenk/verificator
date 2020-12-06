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
    
    private var viewModel: CardIdReaderViewModelType
    init(viewModel: CardIdReaderViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissTap(_:))
        )
        title = viewModel.title
        
        mainView.labelDescription.text = viewModel.description
        mainView.buttonFlipCamera.addTarget(self, action: #selector(buttonFlipCameraTap(_:)), for: .touchUpInside)
        mainView.buttonTakePhoto.addTarget(self, action: #selector(buttonTakePhotoTap(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.endSession()
        
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
    
    private func initiateSession(position: AVCaptureDevice.Position) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession(position: position)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard granted else {
                    self?.viewModel.reportError(.noCameraAccess)
                    return
                }
                self?.viewModel.startSession()
            })
        default:
            viewModel.reportError(.noCameraAccess)
        }
    }
    
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
        mediaType: .video,
        position: .unspecified
    )
    
    private func setupCaptureSession(position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()
        
        let devices = videoDeviceDiscoverySession.devices
        guard let device = devices.first(where: { $0.position == position }) ?? devices.first else {
            viewModel.reportError(.noCameraDevice)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.inputs.forEach({ captureSession.removeInput($0) })
            captureSession.outputs.forEach({ captureSession.removeOutput($0) })
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
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

extension CardIdReaderViewController: CardIdReaderViewType {
    func update(state: CardIdReaderState) {
        switch state {
        case .session(cameraType: let cameraType):
            mainView.buttonTakePhoto.isEnabled = true
            mainView.labelError.isHidden = true
            mainView.cameraView.isHidden = false
            
            let position: AVCaptureDevice.Position
            switch cameraType {
            case .back:
                position = .back
            case .front:
                position = .front
            }
            initiateSession(position: position)
        case .failure(message: let message):
            mainView.buttonTakePhoto.isEnabled = false
            mainView.labelError.isHidden = false
            mainView.labelError.text = message
            mainView.cameraView.isHidden = true
        case .idle:
            mainView.buttonTakePhoto.isEnabled = false
            mainView.labelError.isHidden = true
            mainView.cameraView.isHidden = true
            suspendSession()
        case .photoCapturing:
            mainView.buttonTakePhoto.isEnabled = false
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

extension CardIdReaderViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let e = error {
                self?.viewModel.reportError(.system(message: e.localizedDescription))
                return
            }
            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
            self?.viewModel.processPhoto(image: image)
        }
    }
}
