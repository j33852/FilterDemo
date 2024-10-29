//
//  CameraViewModel.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/17.
//

import Foundation
import SwiftUI
import Photos

enum FilterStatus {
    case fileter
    case edit
}

class CameraViewModel: ObservableObject {
    
    // CameraView
    @Published var capturedImage: UIImage? = nil
    @Published var isCameraActive = true
    @Published var didTapCapture = false
    @Published var isScaling = false
    
    // LibraryView
    @Published var fetchResult: PHFetchResult<PHAsset>?
    @Published var selectedImage: UIImage? = nil
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
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
    
    // TODO: 写真の比例はまた確認することが必要
    func cropPhotoAndSave(image: UIImage) {
        
        guard let cgImage = image.cgImage else { return }

        // 写真のサイズを調整する
        let originalSize = CGSize(width: cgImage.width, height: cgImage.height)
        let width = originalSize.width
        let height = isScaling ? width * 1.33 : width
        
        let cropX = (originalSize.width - width) / 2
        let cropY = (originalSize.height - height) / 2
        let cropRect = CGRect(x: cropX, y: cropY, width: width, height: height)
        
        print("Sizes: \(width), \(height), \(cropX), \(cropY)")
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return }
        
        let croppedImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let finalImage = renderer.image { _ in
            croppedImage.draw(in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        }
        
        capturedImage = finalImage
        
        // 調整した写真を保存する
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: croppedImage)
        }
    }
}
