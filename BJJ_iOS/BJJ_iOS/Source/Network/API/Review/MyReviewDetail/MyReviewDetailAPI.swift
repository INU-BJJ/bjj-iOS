//
//  MyReviewDetailAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/6/25.
//

import Foundation
import Alamofire

final class MyReviewDetailAPI {
    static func deleteMyReview(reviewID: Int, completion: @escaping (Result<Empty, Error>) -> Void) {
        networkRequest(
            urlStr: MyReviewDetailAddress.deleteMyReview(reviewID).url,
            method: .delete,
            data: nil,
            model: Empty.self,
            completion: completion
        )
    }
    
    static func fetchMyReviewDetail(reviewID: Int, completion: @escaping (Result<MyReviewDetailModel, Error>) -> Void) {
        networkRequest(
            urlStr: MyReviewDetailAddress.fetchMyReviewDetail(reviewID).url,
            method: .get,
            data: nil,
            model: MyReviewDetailModel.self,
            completion: completion
        )
    }
}
