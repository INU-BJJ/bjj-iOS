//
//  ReviewWriteAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/3/25.
//

import Foundation

enum ReviewWriteAddress {
    case fetchMenuList
    
    var url: String {
        switch self {
        case .fetchMenuList:
            return "today-diets/main-menus"
        }
    }
}
