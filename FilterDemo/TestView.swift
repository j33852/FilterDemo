//
//  TestView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/15.
//

import SwiftUI

struct TestView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @State private var selectedImgae: UIImage? = nil
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var body: some View {
        VStack {
            if let image = selectedImgae {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth, height: 300)
            } else {
                Text("Choose one photo")
                    .frame(width: screenWidth, height: 300)
            }
            
            Divider()
            
//            CustomPhotoLibraryView(viewModel: viewModel, selectedImage: $selectedImgae)
//                .frame(width: screenWidth, height: 400)
        }
    }
}

#Preview {
    TestView()
}
