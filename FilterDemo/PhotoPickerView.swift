//
//  PhotoPickerView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/15.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI

class CustomPhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var viewModel: CameraViewModel?
    private var collectionView: UICollectionView!
    var onSelectImage: ((UIImage) -> Void)?
    var onHeightUpdate: ((CGFloat) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPhotoLibraryPermission()
        
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            // 第一次請求權限
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        // 如果授權成功，重新加載 collectionView
//                        self?.collectionView.reloadData()
                        self?.configureCollectionView()
                    }
                }
            }
        case .authorized:
            // 已經有權限，直接加載相簿
            self.configureCollectionView()
        default:
            // 其他情況（拒絕或受限），可以顯示警告或提示
            break
        }
    }
    

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let numberOfItemsPerRow: CGFloat = 4
        let spacing: CGFloat = 1
        
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (view.bounds.width - totalSpacing) / numberOfItemsPerRow
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        if let asset = viewModel?.fetchResult?.object(at: 0) {
            // 選中照片後取得完整圖像
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                if let image = image {
                    self?.onSelectImage?(image)
                }
            }
        }
        
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        onHeightUpdate?(height)
    }

 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.fetchResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let asset = viewModel?.fetchResult?.object(at: indexPath.item) {
            
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            let numberOfItemsPerRow: CGFloat = 4
            let itemWidth = view.bounds.width / numberOfItemsPerRow - 0.1
            let targetSize = CGSize(width: itemWidth * UIScreen.main.scale, height: itemWidth * UIScreen.main.scale)
            // 透過 PHImageManager 取得縮略圖
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
                imageView.image = image
            }
            
            cell.contentView.addSubview(imageView)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = viewModel?.fetchResult?.object(at: indexPath.item) {
            // 選中照片後取得完整圖像
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                if let image = image {
                    self?.onSelectImage?(image)
                }
            }
        }
    }
}

struct CustomPhotoLibraryView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
//    @Binding var selectedImage: UIImage?
    var onHeightUpdate: ((CGFloat) -> Void)

    func makeUIViewController(context: Context) -> CustomPhotoLibraryViewController {
        let viewController = CustomPhotoLibraryViewController()
        viewController.onSelectImage = { image in
//            self.selectedImage = image
            viewModel.selectedImage = image
        }
        viewController.viewModel = viewModel
        viewController.onHeightUpdate = onHeightUpdate
        return viewController
    }

    func updateUIViewController(_ uiViewController: CustomPhotoLibraryViewController, context: Context) {}
}
