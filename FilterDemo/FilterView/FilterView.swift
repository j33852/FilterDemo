//
//  FilterView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/28.
//

import SwiftUI

enum EditFuctions {
    case sliderFromLeft
    case sliferFromCenter
    case blur
    case none
}

struct FilterView: View {
    @ObservedObject var viewModel: CameraViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedIndex = 0 // 0: フィルター、1: 編集する、2: キャンセル、3: 完了
    @State private var editFuctions: EditFuctions = .none
    @State private var title = "傾き"
    
    // TODO: フィルターの内容は一つのModelで変更する、また次のページに送る
//    @State private var filterModel:
    @State private var value: Double = 0

    let screenWidth = UIScreen.main.bounds.width
    
    var filterItems = ["なし", "レア", "ミディアム", "ウエルだん", "炒め物", "お肉", "お刺身", "煮物", "揚げ物", "サラダ", "ビグニック", "キャンドル"]
    var editItems = ["傾き", "ぼかし", "ヴィネット", "明るさ", "鮮やかさ", "コントラスト", "暖かさ", "ハイライト", "影", "ガンマ", "シャープ"]
    var blurItems = ["ぼかし解除", "円型", "線型", "指"]
    
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
            
            switch editFuctions{
            case .none:
                sliderEditView
            case .sliderFromLeft:
                sliderFromLeftView
            case .sliferFromCenter:
                sliderFromCenterView
            case .blur:
                blurView
            }
            
            Spacer()
            HStack(spacing: 50) {
                switch editFuctions {
                case .none:
                    filterToggleButtonView(titleName: "フィルター", index: 0)
                    filterToggleButtonView(titleName: "編集する", index: 1)
                default:
                    filterToggleButtonView(titleName: "キャンセル", index: 2) {
                        editFuctions = .none
                    }
                    filterToggleButtonView(titleName: "完了", index: 3) {
                        
                    }
                }
            }
            
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    FilterView(viewModel: CameraViewModel())
}

extension FilterView {
    func filterToggleButtonView(titleName: String, index: Int, action: (() -> Void)? = nil) -> some View {
        Button {
            withAnimation {
                selectedIndex = index
                action?()
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
            .opacity(editFuctions != .none ? 0 : 1)
            .disabled(editFuctions != .none ? true : false)
            
            Spacer()
            
            Text(title)
                .opacity(editFuctions == .none ? 0 : 1)
            
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
            .opacity(editFuctions != .none ? 0 : 1)
            .disabled(editFuctions != .none ? true : false)
            
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
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: screenWidth / 5.5, height: screenWidth / 5.5)
                    .cornerRadius(3)
                
            }
            
            if !isLast {
                Spacer()
                
                Divider()
                    .frame(width: 1, height: (screenWidth / 5.5) + 10)
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


// Edit Views
extension FilterView {
    var sliderEditView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if selectedIndex == 0 {
                    ForEach(filterItems.indices, id: \.self) { index in
                        let item = filterItems[index]
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
                                editFuctions = .sliderFromLeft
                                title = item
                            }
                        } else {
                            editCell(item: item) {
                                print(item)
                                title = item
                                switch index {
                                case 2, 8, 9: editFuctions = .sliderFromLeft
                                case 0, 3, 4, 5, 6, 7: editFuctions = .sliferFromCenter
                                default: editFuctions = .blur
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var sliderFromLeftView: some View {
        VStack {
            Slider(value: $value, in: 0...100)
            Text("Value: \(Int(value))")
                .padding(.top, 10)
        }
        .padding()
    }
    
    var sliderFromCenterView: some View {
        VStack {
            Slider(value: Binding(
                get: { self.value },
                set: { newValue in
                    if abs(newValue) < 15 {
                        self.value = 0
                    } else {
                        self.value = newValue
                    }
                }
            ), in: -100...100)
            
            Text("Value: \(Int(value))")
                .padding(.top, 10)
        }
        .padding()
    }
    
    var blurView: some View {
        HStack {
            ForEach(blurItems.indices, id: \.self) { index in
                let item = blurItems[index]
                
                if index == blurItems.count - 1 {
                    editCell(item: item, isLast: true) {
                        title = item
                    }
                } else {
                    editCell(item: item) {
                        title = item
                    }
                }
            }
        }
    }
}

