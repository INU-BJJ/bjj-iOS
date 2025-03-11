//
//  ReviewWriteAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/3/25.
//

import Foundation

enum ReviewWriteAddress {
    case fetchMenuList
    case postReview
    
    var url: String {
        switch self {
        case .fetchMenuList:
            return "today-diets/main-menus"
        case .postReview:
            return "reviews"
        }
    }
}
