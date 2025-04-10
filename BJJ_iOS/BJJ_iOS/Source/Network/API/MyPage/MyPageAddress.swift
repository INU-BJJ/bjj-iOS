//
//  MyPageAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import Foundation

enum MyPageAddress {
    case fetchMyPageInfo
    
    var url: String {
        switch self {
        case .fetchMyPageInfo:
            return "items/my"
        }
    }
}
