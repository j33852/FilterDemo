//
//  SheetData.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/11/06.
//

import Foundation

enum CommonSheetData {
}

enum CommonSheetStatus {
    case showPhoto
    case showRecipe
    case showOption
}

enum PostStatus: CaseIterable, Identifiable{
    case `public`
    case `private`
    case draft
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .private: "非公開（アーカイブ）"
        case .public: "公開"
        case .draft: "下書き"
        }
    }
}
