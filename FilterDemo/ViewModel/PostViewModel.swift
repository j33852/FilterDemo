//
//  PostViewModel.swift
//  FilterDemo
//
//  Created by Shunketsu Cho on 2024/11/06.
//

import Foundation
import SwiftUI

class PostViewModel: ObservableObject {
    
    // headerView
    @Published var postStatus: PostStatus = .public
    @Published var selectedStatus: PostStatus = .public
    
    // contentView
    @Published var commonSheetStatus: CommonSheetStatus?
    @Published var title: String = ""
    @Published var comment: String = ""
    @Published var isHandmade = false
}
