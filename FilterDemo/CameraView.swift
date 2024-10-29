//
//  CameraView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/11.
//

import SwiftUI

struct CameraView: View {
//    @State private var captruedImage: UIImage? = nil
//    @State private var isCameraActive = true
//    @State private var didTapCapture = false
//    @State private var isScale = false
    
    @ObservedObject var viewModel: CameraViewModel
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            
            ZStack {
                
                CameraCaptureView(viewModel: viewModel)
                    .frame(width: screenWidth, height: viewModel.isScaling ? screenWidth * 1.33 : screenWidth)
//                    .clipped()
                
                if let image = viewModel.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth, height: viewModel.isScaling ? screenWidth * 1.33 : screenWidth)
//                        .clipped()
                }
                

                VStack {
                    Spacer()
                    HStack {
                        CameraButtonView(imageName: "square.stack.3d.down.right") {
                            
                        }
                        
                        Spacer()
                        
                        AiButtonView(aiPoint: "100") {
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                }
            }
            .frame(width: screenWidth, height: viewModel.isScaling ? screenWidth * 1.33 : screenWidth)
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    viewModel.takePhoto()
//                    if viewModel.isCameraActive {
//                        viewModel.didTapCapture = true
//                    } else {
//                        viewModel.capturedImage = nil
//                    }
//
//                    viewModel.isCameraActive.toggle()
                    
                    
                } label: {
                    Image(systemName: "circle.dashed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            
            
        }
    }
}

//#Preview {
//    CameraView(viewModel: <#CameraViewModel#>)
//}
