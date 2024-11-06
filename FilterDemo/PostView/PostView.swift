//
//  PostView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/28.
//

import SwiftUI
import Introspect // version: 0.5.0を使う

struct PostView: View {
    @State private var items = Array(1...5)
    @State private var contentHeight: CGFloat = 30
    @State private var text = ""
    @State private var isSheetPresent = false
    @State private var postStatus: PostStatus = .public
    @State private var selectedStatus: PostStatus = .public
    @State private var commonSheetStatus: CommonSheetStatus?
    @FocusState var focusField: Bool
    
    @Environment(\.dismiss) var dismiss
    let screenHeight = UIScreen.main.bounds.height
    
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
                        selectedStatus = postStatus
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

extension PostView {
    var content: some View {
        VStack {
            HStack(spacing: 20) {
                Button("Plus") {
                    items.append(items.count + 1)
                }
                
                Button("Minus") {
                    items.remove(at: 0)
                }
            }
            
            ZStack(alignment: .topLeading) {
                Text("Placeholder")
                    .foregroundColor(.gray)
                    .font(.body)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 9)
                    .opacity(text.isEmpty ? 1 : 0)
                
                TextEditor(text: $text)
                    .focused($focusField)
                    .foregroundColor(.black)
                    .font(.body)
                    .opacity(text.isEmpty ? 0.25 : 1)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("完了") {
                                    focusField = false
                                }
                            }
                        }
                        
                    }
                
            }
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 0.5)
            )
            
            
            ForEach(items, id: \.self) { item in
                Text("Item \(item)")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .padding(4)
            }
        }
    }
}

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
                    Text(postStatus.description)
                    
                    Image(systemName: "chevron.down")
                }
            }
            
            Spacer()
            
            Button("投稿する") {
                
            }

            
        }
        .padding(.horizontal, 20)
    }
    
    var sheetView: some View {
        VStack(alignment: .center)  {
            HStack {
                Button("キャンセル") {
                    isSheetPresent.toggle()
                    selectedStatus = postStatus
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Button("決定") {
                    isSheetPresent.toggle()
                    postStatus = selectedStatus
                }
                .padding(.trailing, 10)
            }
            .frame(height: 40)
            .background(Color(UIColor.systemGray6))
            .foregroundColor(.gray)
            .font(.headline)
            .offset(y: -30)
                    
            
            Picker("", selection: $selectedStatus) {
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

#Preview {
    PostView()
}

struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

