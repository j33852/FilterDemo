//
//  CameraRootView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/11.
//

import SwiftUI

struct CameraRootView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var selectedIndex = 0 // 0: カメラ、1: ライブラリ
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                headerView
                
                TabView(selection: $selectedIndex) {
                    CameraView(viewModel: viewModel)
                        .tag(0)
                    LibraryView(viewModel: viewModel)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.bottom)
                
                HStack(spacing: 50) {
                    // 左边按钮
                    cameraToggleButtonView(imageName: "camera", titleName: "カメラ", index: 0)
                    cameraToggleButtonView(imageName: "photo", titleName: "ライブラリ", index: 1)
                    
                }
            }
        }
    }
}

#Preview {
    CameraRootView()
}

extension CameraRootView {
    func cameraToggleButtonView(imageName: String, titleName: String, index: Int) -> some View {
        Button {
            withAnimation {
                selectedIndex = index
            }
           
        } label: {
            HStack(spacing: 3) {
                
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
                
                Text(titleName)
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
    }
    
    var headerView: some View {
        HStack {
            CameraButtonView(imageName: "x.circle") {
                dismiss()
            }
            
            switch selectedIndex {
            case 0:
                Spacer()
                
                HStack(spacing: 20) {
                    switch viewModel.isCameraActive {
                    case true:
                        CameraButtonView(imageName: "grid") {
                            
                        }
                        CameraButtonView(imageName: "1.lane") {
                            viewModel.toggleScaling()
                        }
                        CameraButtonView(imageName: "lightbulb.min") {
                            
                        }
                    case false:
                        NavigationLink {
                            FilterView(viewModel: viewModel)
                        } label: {
                            Image(systemName: "arrowshape.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                    }
                   
                }
            default :
                Spacer()
                
                Button {
                    
                } label: {
                    Text("カメラロール")
                }

                Spacer()
                
                NavigationLink {
                    FilterView(viewModel: viewModel)
                } label: {
                    Image(systemName: "arrowshape.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
            }
            
        }
        .padding(.horizontal, 20)
    }
}
