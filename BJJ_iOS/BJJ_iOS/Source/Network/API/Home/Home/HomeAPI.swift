//
//  HomeAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 12/26/24.
//

import Foundation

final class HomeAPI {
    static func fetchHomeAllMenuInfo(cafeteriaName: String, completion: @escaping (Result<[HomeMenuInfo], Error>) -> Void) {
            networkRequest(
                urlStr: HomeAddress.fetchAllMenuInfo.url,
                method: .get,
                data: nil,
                model: [HomeMenuInfo].self,
                query: ["cafeteriaName": cafeteriaName],
                completion: completion
            )
        }
    
    static func fetchCafeteriaInfo(cafeteriaName: String, completion: @escaping (Result<[HomeCafeteriaInfo], Error>) -> Void) {
        networkRequest(
            urlStr: HomeAddress.fetchCafeteriaInfo(cafeteriaName).url,
            method: .get,
            data: nil,
            model: [HomeCafeteriaInfo].self,
            completion: completion
        )
    }
}
