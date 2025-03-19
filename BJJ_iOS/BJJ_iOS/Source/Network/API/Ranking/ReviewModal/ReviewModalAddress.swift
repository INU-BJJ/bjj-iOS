//
//  ReviewModalAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/18/25.
//

import Foundation

enum ReviewModalAddress {
    case fetchBestReview(Int)
    
    var url: String {
        switch self {
        case .fetchBestReview(let bestReviewID):
            return "reviews/\(bestReviewID)"
        }
    }
}
