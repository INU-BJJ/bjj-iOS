//
//  MyPageAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import Foundation
import Alamofire

final class MyPageAPI {
    static func fetchMyPageInfo(completion: @escaping (Result<MyPage, Error>) -> Void) {
        networkRequest(
            urlStr: MyPageAddress.fetchMyPageInfo.url,
            method: .get,
            data: nil,
            model: MyPage.self,
            completion: completion
        )
    }
    
    static func patchItem(itemType: String, itemID: Int, completion: @escaping (Result<Empty, Error>) -> Void) {
        networkRequest(
            urlStr: MyPageAddress.patchItem(itemID).url,
            method: .patch,
            data: nil,
            model: Empty.self,
            query: ["itemType": itemType],
            completion: completion
        )
    }
}
