//
//  File.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/11.
//

import Foundation
import AVFoundation
import SwiftUI

struct CameraCaptureView: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> CustomCameraController {
        let controller = CustomCameraController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
        
        // ここでviewModelの変数を変更しない
        if viewModel.didTapCapture {
            cameraViewController.didTapRecord()
        }
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CameraCaptureView
        
        init(_ parent: CameraCaptureView) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
                        
            if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
                
                parent.viewModel.cropPhotoAndSave(image: image)
            }
            
            parent.viewModel.didTapCapture = false

        }
    }
}

class CustomCameraController: UIViewController {
    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        cameraPreviewLayer?.frame = view.bounds
    }
    
    func setupCamera() {
        captureSession.sessionPreset = .photo
        
        // 配置設備
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
        
        captureSession.addInput(input)
        
        // 配置輸出
        captureSession.addOutput(photoOutput)
        
        // 配置預覽層
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        if let cameraPreviewLayer = cameraPreviewLayer {
            view.layer.addSublayer(cameraPreviewLayer)
        }
        
        captureSession.startRunning()
    }
    
    func didTapRecord() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: delegate!)
    }
}
