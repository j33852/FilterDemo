//
//  LibraryView.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/10/11.
//

import SwiftUI

struct LibraryView: View {
    let symbols = [Symbol(imageName: "drop.fill", name: "drop"),
                   Symbol(imageName: "flame.fill", name: "flame"),
                   Symbol(imageName: "bolt.fill", name: "bolt"),
                   Symbol(imageName: "leaf.fill", name: "leaf"),
                   Symbol(imageName: "hare.fill", name: "hare"),
                   Symbol(imageName: "tortoise.fill", name: "tortoise")
        ]
        
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 4)

    @ObservedObject var viewModel: CameraViewModel
//    @State private var selectedImage: UIImage? = nil
    @State private var photoLibraryHeight: CGFloat = 0
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .bottom) {

                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth, height: UIScreen.main.bounds.height * 0.4)
                        .clipped()
                } else {
                    Text("Choose one photo")
                }
                      
                
                HStack {
                    CameraButtonView(imageName: "square.stack.3d.down.right") {
                        
                    }
                    
                    Spacer()
                    
                    
                    AiButtonView(aiPoint: "100") {
                        
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom)
            }
            .frame(width: screenWidth, height: UIScreen.main.bounds.height * 0.40)
//            .background(Color.yellow)
            
            Spacer()
            
            ScrollView {
                VStack {
                    HStack {
                        wordButton(title: "下書き") {
                            
                        }
                        Spacer()
                        wordButton(title: "編集") {
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(symbols) { symbol in
                                Image(systemName: symbol.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: (screenWidth - 3) / 4, height: (screenWidth - 3) / 4)
                                    .background(Color.red)
                        }
                    }
                    
                    HStack {
                        Text("カメラロール")
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    CustomPhotoLibraryView(viewModel: viewModel, onHeightUpdate: { height in
                        DispatchQueue.main.async {
                            photoLibraryHeight = height

                        }
                    })
                        .frame(width: screenWidth, height: photoLibraryHeight)
                    
                }
            }
        }
    }
}

//#Preview {
//    LibraryView()
//}

extension LibraryView {
    
    func wordButton(title: String, action: @escaping () -> Void) -> some View {
        
        Button(action: action, label: {
            Text(title)
        })
    }
}
