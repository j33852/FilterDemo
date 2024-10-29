//
//  PostView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/28.
//

import SwiftUI

struct PostView: View {
    
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    PostView()
}

extension PostView {
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
                CameraButtonView(imageName: "arrowshape.right") {
                }
                .padding(.trailing)
            
            
        }
        .padding(.horizontal, 20)
    }
}
