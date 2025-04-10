//
//  MyPageAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import Foundation

final class MyPageAPI {
    static func fetchMyPageInfo(completion: @escaping (Result<MyPageModel, Error>) -> Void) {
        networkRequest(
            urlStr: MyPageAddress.fetchMyPageInfo.url,
            method: .get,
            data: nil,
            model: MyPageModel.self,
            completion: completion
        )
    }
}
