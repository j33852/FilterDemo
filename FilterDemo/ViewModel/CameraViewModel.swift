//
//  CameraViewModel.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/17.
//

import Foundation
import SwiftUI

enum CameraStatus {
    case camera
    case library
}

class CameraViewModel: ObservableObject {
    
    // RootView
    @Published var cameraStatus: CameraStatus = .camera
    
    // CameraView
    @Published var capturedImage: UIImage? = nil
    @Published var isCameraActive = true
    @Published var didTapCapture = false
    @Published var isScaling = false
    
    
    // LibraryView
    
    
    func toggleScaling() {
        isScaling = !isScaling
    }
    
    func takePhoto() {
        // カメラオン場合は写真を撮る。オフ場合は写真を削除する
        if isCameraActive {
            didTapCapture = true
        } else {
            capturedImage = nil
        }
        
        isCameraActive.toggle()
    }
}
