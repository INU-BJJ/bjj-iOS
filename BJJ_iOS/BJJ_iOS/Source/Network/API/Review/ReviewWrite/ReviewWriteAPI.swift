//
//  ReviewWriteAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/3/25.
//

import UIKit

final class ReviewWriteAPI {
    static func fetchMenuList(cafeteriaName: String, completion: @escaping (Result<[ReviewWriteMenuInfo], Error>) -> Void) {
        networkRequest(
            urlStr: ReviewWriteAddress.fetchMenuList.url,
            method: .get,
            data: nil,
            model: [ReviewWriteMenuInfo].self,
            query: ["cafeteriaName": cafeteriaName],
            completion: completion
        )
    }
    
    static func postReview(params: [String: Any], images: [UIImage], completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        // TODO: multi-part form data 함수로 변경
        networkRequest(
            urlStr: ReviewWriteAddress.postReview.url,
            method: .post,
            data: data,
            model: EmptyResponse.self,
            completion: completion
        )
    }
}
