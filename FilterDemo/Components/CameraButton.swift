//
//  CameraButton.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/16.
//

import SwiftUI

struct CameraButtonView: View {
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.black)
        }

    }
}

struct AiButtonView: View {
    let aiPoint: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(aiPoint)
                    .font(.title)
                    .foregroundColor(.black)
                
                Image(systemName: "automatic.brakesignal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 30)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    CameraButtonView(imageName: "", action: {
        
    })
}
