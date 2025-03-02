//
//  MyReviewAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/24/25.
//

import Foundation

final class MyReviewAPI {
    static func fetchMyReview(completion: @escaping (Result<MyReviewList, Error>) -> Void) {
            networkRequest(
                urlStr: MyReviewAddress.fetchMyReview.url,
                method: .get,
                data: nil,
                model: MyReviewList.self,
                completion: completion
            )
        }
}
