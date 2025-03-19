//
//  ReviewModalAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/18/25.
//

import Foundation

final class ReviewModalAPI {
    static func fetchBestReview(bestReviewID: Int, completion: @escaping (Result<BestReviewModel, Error>) -> Void) {
        networkRequest(
            urlStr: ReviewModalAddress.fetchBestReview(bestReviewID).url,
            method: .get,
            data: nil,
            model: BestReviewModel.self,
            completion: completion
        )
    }
}
