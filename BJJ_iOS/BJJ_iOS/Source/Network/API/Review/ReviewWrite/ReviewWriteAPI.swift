//
//  ReviewWriteAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/3/25.
//

import Foundation

final class ReviewWriteAPI {
    static func fetchReviewWriteMenuInfo(cafeteriaName: String, completion: @escaping (Result<[ReviewWriteMenuInfo], Error>) -> Void) {
            networkRequest(
                urlStr: ReviewWriteAddress.fetchMenuList.url,
                method: .get,
                data: nil,
                model: [ReviewWriteMenuInfo].self,
                query: ["cafeteriaName": cafeteriaName],
                completion: completion
            )
        }
}
