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
    case postIsMenuLiked(Int)
    case postIsReviewLiked(Int)
    
    var url: String {
        switch self {
        case .fetchReviewInfo:
            return "reviews"
        case .fetchReviewImageList:
            return "reviews/images"
        case .postIsMenuLiked(let menuID):
            return "menus/\(menuID)/like"
        case .postIsReviewLiked(let reviewID):
            return "reviews/\(reviewID)/like"
        }
    }
}
