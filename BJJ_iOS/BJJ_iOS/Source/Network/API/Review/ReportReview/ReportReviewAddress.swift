//
//  ReportReviewAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/16/25.
//

import Foundation

enum ReportReviewAddress {
    case postReportReview(Int)
    
    var url: String {
        switch self {
        case .postReportReview(let reviewID):
            return "reviews/\(reviewID)/report"
        }
    }
}
