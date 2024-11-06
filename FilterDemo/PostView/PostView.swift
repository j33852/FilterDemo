//
//  PostView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/28.
//

import SwiftUI
import Introspect // version: 0.5.0を使う


struct PostView: View {
    @State private var items = ["Yummy!!", "キャンペーン", "秋の行楽弁当"]
    @State private var contentHeight: CGFloat = 30
    @State private var text = ""
    @State private var isSheetPresent = false
    @State private var isTitleEdit = false
    @State private var isCommentEdit = false
    
    @StateObject private var viewModel = PostViewModel()
    @FocusState var focusField: Bool
    
    @Environment(\.dismiss) var dismiss
    let screenHeight = UIScreen.main.bounds.height
    let iconWidth: CGFloat = 24
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                
                GeometryReader { geometry in
                    ScrollView {
                        content
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: ContentHeightKey.self, value: proxy.size.height)
                                }
                            )
                    }
                    .introspectScrollView { scrollView in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            scrollView.isScrollEnabled = contentHeight > geometry.size.height
                        }
                    }
                }
                .onPreferenceChange(ContentHeightKey.self) { newContentHeight in
                    contentHeight = newContentHeight
                }
                
                Spacer()
                
            }
            
            if isSheetPresent {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isSheetPresent.toggle()
                        viewModel.selectedStatus = viewModel.postStatus
                    }
                
                VStack {
                    Spacer()
                    sheetView
                    
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut(duration: 0.5), value: isSheetPresent)
                             
            }
        }
    }
}

// ContentView
extension PostView {
    var content: some View {
        VStack {
//            HStack(spacing: 20) {
//                Button("Plus") {
//                    items.append(items.count + 1)
//                }
//                
//                Button("Minus") {
//                    items.remove(at: 0)
//                }
//            }
            
            // 入力欄
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: "car.front.waves.down")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ZStack(alignment: .leading) {
                            if viewModel.title.isEmpty {
                                Text("料理名を入力")
                                    .foregroundColor(.gray)
                            }
                            
                            Text(viewModel.title)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    isTitleEdit = true
                                }
                        }
                        
                        Divider()
                            .frame(height: 2)
                        
                        ZStack(alignment: .leading) {
                            if viewModel.comment.isEmpty {
                                Text("お料理のきっかけ、コメント、#ハッシュタグ")
                                    .foregroundColor(.gray)
                            }
                            
                            Text(viewModel.comment)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    isCommentEdit = true
                                }
                        }
                    }
                }
                                
                Text("#ハッシュタグ・ジャンルを追加")
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding()
                    .onTapGesture {
                        
                    }
            }
            .font(.subheadline)
            
            
            VStack {
                Divider()
                Spacer()
                
                // 手料理マーク
                HStack {
                    Image(systemName: "atom")
                        .resizable()
                        .frame(width: iconWidth, height: iconWidth)
                        .padding(.trailing, 10)
                    Text("手料理マーク")
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.isHandmade)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                Divider()
                
                // プレゼント企画
                presentView
                
                // 使ってみた商品
                postCellView(commonSheetStatus: .showProduct)
                // つくフォトを送る
                postCellView(commonSheetStatus: .showPhoto)
                // レシピ
                postCellView(commonSheetStatus: .showRecipe)
                // オプション
                postCellView(commonSheetStatus: .showOption)
                // SNS
                HStack {
                   
                    Text("投稿してSNS共有")
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Image(systemName: "questionmark.circle")
                    
                }
                .padding(.horizontal, 20)

            }
            
//            ZStack(alignment: .topLeading) {
//                Text("Placeholder")
//                    .foregroundColor(.gray)
//                    .font(.body)
//                    .padding(.horizontal, 4)
//                    .padding(.vertical, 9)
//                    .opacity(text.isEmpty ? 1 : 0)
//                
//                TextEditor(text: $text)
//                    .focused($focusField)
//                    .foregroundColor(.black)
//                    .font(.body)
//                    .opacity(text.isEmpty ? 0.25 : 1)
//                    .toolbar {
//                        ToolbarItem(placement: .keyboard) {
//                            HStack {
//                                Spacer()
//                                Button("完了") {
//                                    focusField = false
//                                }
//                            }
//                        }
//                        
//                    }
//                
//            }
//            .padding(4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color.red, lineWidth: 0.5)
//            )
//            
//            
//            ForEach(items, id: \.self) { item in
//                Text("Item \(item)")
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue.opacity(0.2))
//                    .cornerRadius(8)
//                    .padding(4)
//            }
        }
    }
}

// HeaderView & SheetView
extension PostView {
    var headerView: some View {
        HStack {
            CameraButtonView(imageName: "x.circle") {
                dismiss()
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    isSheetPresent.toggle()
                }
                
            } label: {
                HStack {
                    Text(viewModel.postStatus.description)
                    
                    Image(systemName: "chevron.down")
                }
            }
            
            Spacer()
            
            Button("投稿する") {
                
            }
        }
        .padding(.horizontal, 20)
    }
    
    
    var presentView: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "gift")
                    .resizable()
                    .frame(width: iconWidth, height: iconWidth)
                    .padding(.trailing, 10)
                
                Text("プレゼント企画")
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                HStack {
                    Image(systemName: "fireworks")
                        .resizable()
                        .frame(width: iconWidth, height: iconWidth)
                    Text(item)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
                .padding(.horizontal, 20)
                .padding(.bottom, index == items.count - 1 ? 20 : 0)
                .onTapGesture {
                    
                }
            }
            
            Spacer()
            Divider()
        }
    }
    
    var sheetView: some View {
        VStack(alignment: .center)  {
            HStack {
                Button("キャンセル") {
                    isSheetPresent.toggle()
                    viewModel.selectedStatus = viewModel.postStatus
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Button("決定") {
                    isSheetPresent.toggle()
                    viewModel.postStatus = viewModel.selectedStatus
                }
                .padding(.trailing, 10)
            }
            .frame(height: 40)
            .background(Color(UIColor.systemGray6))
            .foregroundColor(.gray)
            .font(.headline)
            .offset(y: -30)
                    
            
            Picker("", selection: $viewModel.selectedStatus) {
                ForEach(PostStatus.allCases) { status in
                    Text(status.description)
                }
                
            }
            .pickerStyle(.wheel)
            
            Spacer()

        }
        .frame(height: screenHeight * 0.25)
        .background(.white)
        
    }
}

// Reused View
extension PostView {
    func postCellView(commonSheetStatus: CommonSheetStatus) -> some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: commonSheetStatus.imageName)
                    .resizable()
                    .frame(width: iconWidth, height: iconWidth)
                    .padding(.trailing, 10)
                
                Text(commonSheetStatus.description)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal, 20)
            
            Spacer()
            Divider()
        }
        
    }
}

#Preview {
    PostView()
}

struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

