//
//  FilterView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/28.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: CameraViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedIndex = 0 // 0: フィルター、1: 編集する
    
    let screenWidth = UIScreen.main.bounds.width
    var image: UIImage?
    
    var filterItems = ["なし", "レア", "ミディアム", "ウエルだん", "炒め物", "お肉", "お刺身", "煮物", "揚げ物", "サラダ", "ビグニック", "キャンドル"]
    var editItems = ["傾き", "ぼかし", "ヴィネット", "明るさ", "鮮やかさ", "コントラスト", "暖かさ", "ハイライト", "影", "ガンマ", "シャープ"]
    
    var body: some View {
      
        VStack {
            headerView
            
            ZStack {
                if let image = viewModel.capturedImage ?? viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth, height: screenWidth * 1.33)
                        .clipped()
                    
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        AiButtonView(aiPoint: "100") {
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                }
            }
            .frame(width: screenWidth, height: screenWidth * 1.33)
            
            ScrollView(.horizontal) {
                HStack {
                    if selectedIndex == 0 {
                        ForEach(filterItems, id: \.self) { item in
                            filterCell(item: item) {
                                print(item)
                            }
                        }
                    } else {
                        ForEach(editItems.indices , id: \.self) { index in
                            let item = editItems[index]
                            if index == editItems.count - 1 {
                                editCell(item: item, isLast: true) {
                                    print(item)
                                }
                            } else {
                                editCell(item: item) {
                                    print(item)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            HStack(spacing: 50) {
                filterToggleButtonView(titleName: "フィルター", index: 0)
                filterToggleButtonView(titleName: "編集する", index: 1)
            }
            
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    FilterView(viewModel: CameraViewModel())
}

extension FilterView {
    func filterToggleButtonView(titleName: String, index: Int) -> some View {
        Button {
            withAnimation {
                selectedIndex = index
            }
        } label: {
            Text(titleName)
                .font(.title2)
                .foregroundColor(.black)
        }
    }
    
    var headerView: some View {
        HStack {
            CameraButtonView(imageName: "x.circle") {
                dismiss()
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("カメラロール")
            }
            
            Spacer()
            
            NavigationLink {
                PostView()
            } label: {
                Image(systemName: "arrowshape.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
            
        }
        .padding(.horizontal, 20)
    }
    
    func filterCell(item: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 1) {
            Text("\(item)")
                .font(.caption2)
                .foregroundColor(.gray)
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: screenWidth / 5, height: screenWidth / 5)
                .cornerRadius(3)
            
        }
        .padding(.horizontal, 1)
        .onTapGesture {
            action()
        }
    }
    
    func editCell(item: String, isLast: Bool = false, action: @escaping () -> Void) -> some View {
        HStack {
            VStack(spacing: 1) {
                Text("\(item)")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: screenWidth / 5.5, height: screenWidth / 5.5)
                    .cornerRadius(3)
                
            }
            
            if !isLast {
                Spacer()
                
                Divider()
                    .frame(width: 1, height: (screenWidth / 5.5) + 5)
                    .background(Color.gray)
                    .padding(.vertical)
            }
        }
        .padding(.horizontal, 1)
        .onTapGesture {
            action()
        }
    }
}
