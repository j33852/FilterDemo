//
//  PhotoViewModel.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/15.
//

import Foundation
import Photos
import SwiftUI

class PhotoViewModel: ObservableObject {
    //ライブラリーのアルバムを取得
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
}
