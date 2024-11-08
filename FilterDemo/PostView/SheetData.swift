//
//  SheetData.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/11/06.
//

import Foundation

enum PostNavigationTarget {
    case none
    case hashTag
    case product
    case qa
}

enum CommonSheetStatus {
    case showPostStatus // 公開　or 非公開
    case showProduct // 使ってみた商品
    case showPhoto // つくフォトを送る
    case showRecipe // レシピ
    case showOption // オプション
    
    var description: String {
        switch self {
        case .showProduct: "使ってみた商品"
        case .showPhoto: "つくフォトを送る"
        case .showRecipe: "レシピ"
        case .showOption: "オプション"
        case .showPostStatus: ""
        }
    }
    
    var imageName: String {
        switch self {
        case .showProduct: "waterbottle"
        case .showPhoto: "frying.pan"
        case .showRecipe: "fork.knife"
        case .showOption: "water.waves"
        case .showPostStatus: ""
        }
    }
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
