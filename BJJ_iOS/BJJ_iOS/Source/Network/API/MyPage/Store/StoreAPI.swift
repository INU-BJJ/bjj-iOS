//
//  StoreAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation

final class StoreAPI {
    static func fetchAllItems(completion: @escaping (Result<[StoreModel], Error>) -> Void) {
        networkRequest(
            urlStr: StoreAddress.fetchAllItems.url,
            method: .get,
            data: nil,
            model: [StoreModel].self,
            completion: completion
        )
    }
}
