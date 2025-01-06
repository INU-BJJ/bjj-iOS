//
//  MenuDetailAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/3/25.
//

import Foundation

final class MenuDetailAPI {
    static func fetchReviewInfo(menuPairID: Int, pageNumber: Int, pageSize: Int, sortingCriteria: String, isWithImage: Bool, completion: @escaping (Result<MenuDetailReview, Error>) -> Void) {
            networkRequest(
                urlStr: MenuDetailAddress.fetchReviewInfo.url,
                method: .get,
                data: nil,
                model: MenuDetailReview.self,
                query: [
                    "menuPairId": menuPairID,
                    "pageNumber": pageNumber,
                    "pageSize": pageSize,
                    "sort": sortingCriteria,
                    "isWithImages": isWithImage
                ],
                completion: completion
            )
        }
}
