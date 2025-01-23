//
//  MenuDetailAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/3/25.
//

import Foundation

enum MenuDetailAddress {
    case fetchReviewInfo
    case fetchReviewImageList
    
    var url: String {
        switch self {
        case .fetchReviewInfo:
            return "reviews"
        case .fetchReviewImageList:
            return "reviews/images"
        }
    }
}
