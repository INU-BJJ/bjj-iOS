//
//  MyReviewDetailAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/6/25.
//

import Foundation

enum MyReviewDetailAddress {
    case deleteMyReview(Int)
    case fetchMyReviewDetail(Int)
    
    var url: String {
        switch self {
        case .deleteMyReview(let reviewID):
            return "reviews/\(reviewID)"
        case .fetchMyReviewDetail(let reviewID):
            return "reviews/\(reviewID)"
        }
    }
}
