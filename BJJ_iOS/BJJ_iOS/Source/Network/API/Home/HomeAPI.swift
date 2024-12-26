//
//  HomeAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 12/26/24.
//

import Foundation

final class HomeAPI {
    static func fetchHomeAllMenuInfo(cafeteriaName: String, completion: @escaping (Result<HomeAllMenuInfo, Error>) -> Void) {
            networkRequest(
                urlStr: HomeAddress.fetchAllMenuInfo.url,
                method: .get,
                data: nil,
                model: HomeAllMenuInfo.self,
                query: ["cafeteriaName": cafeteriaName],
                completion: completion
            )
        }
}
