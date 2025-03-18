//
//  RankingAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import Foundation

final class RankingAPI {
    static func fetchRankingList(pageNumber: Int, pageSize: Int, completion: @escaping (Result<MenuRankingList, Error>) -> Void) {
            networkRequest(
                urlStr: RankingAddress.fetchMenuRanking.url,
                method: .get,
                data: nil,
                model: MenuRankingList.self,
                query: [
                    "pageNumber": pageNumber,
                    "pageSize": pageSize
                ],
                completion: completion
            )
        }
}
