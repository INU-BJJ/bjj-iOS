//
//  MyPageAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import Foundation

enum MyPageAddress {
    case fetchMyPageInfo
    case patchItem(Int)
    
    var url: String {
        switch self {
        case .fetchMyPageInfo:
            return "items/my"
        case .patchItem(let itemID):
            return "items/\(itemID)"
        }
    }
}
