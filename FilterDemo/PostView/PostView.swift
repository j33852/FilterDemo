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
    @State private var titleTextHeight: CGFloat = 20
    @State private var commentTextHeight: CGFloat = 100

    @State private var isSheetPresent = false
    @State private var isTitleEdit = false
    @State private var isCommentEdit = false
    @State private var isCampaignView = false
        
    @StateObject private var viewModel = PostViewModel()
    
    @FocusState var titleFieldFocus: Bool
    @FocusState var commentFieldFocus: Bool
    
    @Environment(\.dismiss) var dismiss
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let iconWidth: CGFloat = 24
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                // タイトル
                headerView
                
                GeometryReader { geometry in
                    ScrollView {
                        // 内容
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
            
            // 入力欄ダイアローグ
            if isTitleEdit || isCommentEdit {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isTitleEdit = false
                        isCommentEdit = false
                }
                
                if isTitleEdit {
                    titleEditView
                } else if isCommentEdit {
                    commentEditView
                }
                
            }
            
            // 投稿状態のsheet
            if isSheetPresent {
                Color.black.opacity(viewModel.commonSheetStatus == .showPostStatus ? 0.4 : 0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isSheetPresent.toggle()
                        viewModel.selectedStatus = viewModel.postStatus
                    }
                
                VStack {
                    Spacer()
                    
                    if viewModel.commonSheetStatus == .showPostStatus {
                        sheetPostStatusView
                    } else if viewModel.commonSheetStatus != .showProduct {
                        sheetView(commonSheetStatus: viewModel.commonSheetStatus)
                    }
                    
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut(duration: 0.5), value: isSheetPresent)
            }
            
            // 次の画面に遷移
            NavigationLink(
                destination: destinationView()
                    .onDisappear { viewModel.postNavigationTarget = .none },
                isActive: .constant(viewModel.postNavigationTarget != .none)
            ) {
                EmptyView()
            }

        }
        .sheet(isPresented: $isCampaignView, onDismiss: {
            
        }, content: {
            PostCampaignView()
        })
        .navigationBarBackButtonHidden()
    }
}

// Functions
extension PostView {
    func updateTextHeight(geometry: GeometryProxy, isTitle: Bool = false) {
        let size = CGSize(width: geometry.size.width, height: .infinity)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        if isTitle {
            let boundingRect = (viewModel.title as NSString).boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
            )
            titleTextHeight = boundingRect.height + 5
        } else {
            let boundingRect = (viewModel.comment as NSString).boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
            )
            commentTextHeight = boundingRect.height + 20
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        switch viewModel.postNavigationTarget {
        case .hashTag:
            ContentView()
        case .product:
            TestView()
        case .qa:
            EmptyView()
        case .none:
            EmptyView()
        }
    }
}

// ContentView
extension PostView {
    var content: some View {
        VStack {
            // 入力欄
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: "car.front.waves.down")
                        .resizable()
                        .frame(width: screenWidth / 5.2, height: screenWidth / 5.2)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ZStack(alignment: .topLeading) {
                            Text(viewModel.title)
                                .foregroundColor(.black)
                            if viewModel.title.isEmpty {
                                Text("料理名を入力")
                                    .foregroundColor(.gray)
                            }
                            
                            Color.clear
                                .frame(maxWidth: .infinity, maxHeight: max(20, titleTextHeight))
                        }
                        .background(.gray.opacity(0.0001))
                        .onTapGesture {
                            isTitleEdit = true
                            titleFieldFocus = true
                        }
                        
                        Divider()
                        
                        ZStack(alignment: .topLeading) {
                            
                            Text(viewModel.comment)
                                .foregroundColor(.black)
                            
                            if viewModel.comment.isEmpty {
                                Text("お料理のきっかけ、コメント、#ハッシュタグ")
                                    .foregroundColor(.gray)
                            }
                            
                            Color.clear
                                .frame(maxWidth: .infinity, maxHeight: max(100, commentTextHeight))
                        }
                        .background(.gray.opacity(0.0001))
                        .onTapGesture {
                            isCommentEdit = true
                            commentFieldFocus = true
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
                        isCommentEdit = true
                        commentFieldFocus = true
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
                    .onTapGesture {
                        isSheetPresent.toggle()
                        viewModel.commonSheetStatus = .showPhoto
                    }
                // レシピ
                postCellView(commonSheetStatus: .showRecipe)
                    .onTapGesture {
                        isSheetPresent.toggle()
                        viewModel.commonSheetStatus = .showRecipe
                    }
                // オプション
                postCellView(commonSheetStatus: .showOption)
                    .onTapGesture {
                        isSheetPresent.toggle()
                        viewModel.commonSheetStatus = .showOption
                    }
                // SNS
                HStack {
                    Text("投稿してSNS共有")
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Image(systemName: "questionmark.circle")
                }
                .padding(.horizontal, 20)

            }
        }
    }
}

// 画面の要素
extension PostView {
    var headerView: some View {
        HStack {
            CameraButtonView(imageName: "x.circle") {
                dismiss()
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    viewModel.commonSheetStatus = .showPostStatus
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
                    isCampaignView.toggle()
                }
            }
            
            Spacer()
            Divider()
        }
    }
    
    var sheetPostStatusView: some View {
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
    
    func sheetView(commonSheetStatus: CommonSheetStatus) -> some View {
        VStack {
            Text(commonSheetStatus.description)
                .foregroundColor(.white)
            
            sheetCellView(commonSheetStatus: commonSheetStatus)
        }
    }
}

// 入力欄ダイアローグ
extension PostView {
    var titleEditView: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    
                    Text("料理名")
                    
                    Spacer()
                    
                    Button("OK") {
                        isTitleEdit = false
                    }
                }
                .padding([.horizontal, .top], 20)
                
                HStack(alignment: .top) {
                    Image(systemName: "car.front.waves.down")
                        .resizable()
                        .frame(width: screenWidth / 5.2, height: screenWidth / 5.2)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.title)
                                .foregroundColor(.black)
                                .focused($titleFieldFocus)
                                .frame(height: max(20, titleTextHeight))
                                .background(GeometryReader { geometry in
                                    Color.clear.onChange(of: viewModel.title) { _ in
                                        updateTextHeight(geometry: geometry, isTitle: true)
                                    }
                                })
                                .toolbar {
                                    ToolbarItem(placement: .keyboard) {
                                        HStack {
                                            Spacer()
                                            Button("完了") {
                                                titleFieldFocus = false
                                            }
                                        }
                                    }
                                }
                            
                            if viewModel.title.isEmpty && !titleFieldFocus {
                                Text("料理名を入力")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        ZStack(alignment: .topLeading) {
                            Text(viewModel.comment)
                                .foregroundColor(.black)
                                .frame(height: max(100, commentTextHeight))
                            
                            if viewModel.comment.isEmpty && !commentFieldFocus {
                                Text("お料理のきっかけ、コメント、#ハッシュタグ")
                                    .foregroundColor(.gray)
                            }
                            
                            Color.clear
                                .frame(maxWidth: .infinity, maxHeight: max(100, commentTextHeight))
                        }
                        .background(.gray.opacity(0.0001))
                        .onTapGesture {
                            isTitleEdit = false
                            isCommentEdit = true
                            commentFieldFocus = true
                        }
                    }
                    .onTapGesture {
                        titleFieldFocus = true
                    }
                }
            }
            .font(.subheadline)
            .background(.white)
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .animation(.easeInOut(duration: 0.5), value: isTitleEdit)
    }

    
    var commentEditView: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    
                    Text("コメント・ハッシュタグ")
                    
                    Spacer()
                    
                    Button("OK") {
                        isCommentEdit = false
                    }
                }
                .padding([.horizontal, .top], 20)
                
                HStack(alignment: .top) {
                    Image(systemName: "car.front.waves.down")
                        .resizable()
                        .frame(width: screenWidth / 5.2, height: screenWidth / 5.2)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.comment)
                                .foregroundColor(.black)
                                .focused($commentFieldFocus)
                                .frame(height: max(100, commentTextHeight))
                                .background(GeometryReader { geometry in
                                    Color.clear.onChange(of: viewModel.comment) { _ in
                                        updateTextHeight(geometry: geometry)
                                    }
                                })
                                .toolbar {
                                    ToolbarItem(placement: .keyboard) {
                                        HStack {
                                            Spacer()
                                            Button("完了") {
                                                commentFieldFocus = false
                                            }
                                        }
                                    }
                                }
                            
                            if viewModel.comment.isEmpty && !commentFieldFocus {
                                Text("お料理のきっかけ、コメント、#ハッシュタグ")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onTapGesture {
                        commentFieldFocus = true
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
                        viewModel.postNavigationTarget = .hashTag
                    }
            }
            .font(.subheadline)
            .background(.white)
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .animation(.easeInOut(duration: 0.5), value: isCommentEdit)
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
        .background(.gray.opacity(0.0001))
    }
    
    func sheetCellView(commonSheetStatus: CommonSheetStatus) -> some View {
        let photoItem = [
            PhotoItem(imageName: "star.fill", name: "お気に入りから選択"),
            PhotoItem(imageName: "moon.stars", name: "自分の投稿から選択")
        ]
        
        let recipeItem = [
            PhotoItem(imageName: "star.fill", name: "URLを入力"),
            PhotoItem(imageName: "moon.stars", name: "ウェブで検索"),
            PhotoItem(imageName: "circle.filled.ipad", name: "レシピを書く")
        ]
        
        let optionItem = [
            PhotoItem(imageName: "star.fill", name: "どこ"),
            PhotoItem(imageName: "moon.stars", name: "誰と"),
            PhotoItem(imageName: "lightbulb.max", name: "評価・価格・kcal")
        ]
        
        var items = [PhotoItem]()
        if commonSheetStatus == .showPhoto {
            items = photoItem
        } else if commonSheetStatus == .showRecipe {
            items = recipeItem
        } else {
            items = optionItem
        }
        
        return VStack(spacing: 0) {
            ForEach(items) { item in
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: item.imageName)
                            .resizable()
                            .frame(width: iconWidth + 6, height: iconWidth + 6, alignment: .leading)
                        
                        Spacer()
                        
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    Divider()
                }
                .frame(height: screenHeight * 0.07)
                .background(.white)
            }
            
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
