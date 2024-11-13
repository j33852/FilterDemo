//
//  PostCampaignView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/11/08.
//

import SwiftUI
import WebKit

// TODO: 使った商品と使ったタグを実装
struct PostCampaignView: View {
    
    let url = URL(string: "https://www.yahoo.co.jp/")
    let screenWidth = UIScreen.main.bounds.width
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                CameraButtonView(imageName: "x.circle") {
                    dismiss()
                }
                
                Spacer()
                Text("テスト")
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            PostWebView(url: url!)
            
            
            Button {
                dismiss()
            } label: {
                Text("応募要項に同意して参加する")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, screenWidth * 0.2)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.yellow)
                    )
            }

            
        }
    }
}

#Preview {
    PostCampaignView()
}

struct PostWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
