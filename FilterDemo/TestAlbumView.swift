//
//  TestAlbumView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/11/11.
//

import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var isPhotoPickerPresented = false
    
    // 更新選擇的圖片
    func updateSelectedImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.selectedImage = image
        }
    }
}

struct TestAlbumView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    
    var body: some View {
        VStack {
            // 顯示選中的圖片
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
            } else {
                Text("No Image Selected")
                    .frame(height: 300)
                    .padding()
            }

            // 選擇照片按鈕
            Button("Select Photo") {
                viewModel.isPhotoPickerPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.isPhotoPickerPresented) {
            PhotoPickerView(viewModel: viewModel)
        }
    }
}

struct PhotoPickerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ImagePickerViewModel

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPickerView

        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let uiImage = image as? UIImage {
                        self?.parent.viewModel.updateSelectedImage(uiImage)
                    }
                }
            }
        }
    }
}
