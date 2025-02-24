//
//  MyReviewAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/24/25.
//

import Foundation

enum MyReviewAddress {
    case fetchMyReview
    
    var url: String {
        switch self {
        case .fetchMyReview:
            return "reviews/my"
        }
    }
}
