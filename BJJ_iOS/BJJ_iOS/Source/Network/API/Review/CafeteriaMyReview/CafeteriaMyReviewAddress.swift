//
//  CafeteriaMyReviewAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/5/25.
//

import Foundation

enum CafeteriaMyReviewAddress {
    case fetchCafeteriaMyReview
    
    var url: String {
        switch self {
        case .fetchCafeteriaMyReview:
            return "reviews/my/cafeteria"
        }
    }
}
