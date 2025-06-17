//
//  ReportReviewAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/16/25.
//

import Foundation
import Alamofire

final class ReportReviewAPI {
    static func postReportReview(
        reviewID: Int,
        reportReasons: [String: [String]],
        completion: @escaping (Result<Empty, Error>) -> Void
    ) {
        let data = try? JSONSerialization.data(withJSONObject: reportReasons, options: .prettyPrinted)

        networkRequest(
            urlStr: ReportReviewAddress.postReportReview(reviewID).url,
            method: .post,
            data: data,
            model: Empty.self,
            completion: completion
        )
    }
}
