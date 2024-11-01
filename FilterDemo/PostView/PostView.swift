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
    @FocusState var focusField: Bool
    
    var body: some View {
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

struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

