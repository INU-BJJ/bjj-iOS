//
//  CafeteriaMyReviewAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/5/25.
//

import Foundation

final class CafeteriaMyReviewAPI {
    static func fetchMyReview(completion: @escaping (Result<CafeteriaMyReviewList, Error>) -> Void) {
            networkRequest(
                urlStr: CafeteriaMyReviewAddress.fetchCafeteriaMyReview.url,
                method: .get,
                data: nil,
                model: CafeteriaMyReviewList.self,
                completion: completion
            )
        }
}
