//
//  GachaResultAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation
import Alamofire

final class GachaResultAPI {
    static func postItemGacha(itemType: String, completion: @escaping (Result<GachaResultModel, Error>) -> Void) {
        networkRequest(
            urlStr: GachaResultAddress.postItemGacha.url,
            method: .post,
            data: nil,
            model: GachaResultModel.self,
            query: ["itemType": itemType],
            completion: completion
        )
    }
    
    static func patchItem(itemType: String, itemID: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkRequest(
            urlStr: GachaResultAddress.patchItem(itemID).url,
            method: .patch,
            data: nil,
            model: EmptyResponse.self,
            query: ["itemType": itemType],
            completion: completion
        )
    }
}
