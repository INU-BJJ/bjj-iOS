//
//  MenuDetailAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/3/25.
//

import Foundation

enum MenuDetailAddress {
    case fetchReviewInfo
    
    var url: String {
        switch self {
        case .fetchReviewInfo:
            return "reviews"
        }
    }
}
