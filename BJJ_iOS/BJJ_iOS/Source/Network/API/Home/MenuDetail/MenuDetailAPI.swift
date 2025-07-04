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
    
    static func fetchReviewImageList(menuPairID: Int, pageNumber: Int, pageSize: Int, cancelToken: APICancelToken? = nil, completion: @escaping (Result<MenuDetailReviewImage, Error>) -> Void) {
            networkRequest(
                urlStr: MenuDetailAddress.fetchReviewImageList.url,
                method: .get,
                data: nil,
                model: MenuDetailReviewImage.self,
                query: [
                    "menuPairId": menuPairID,
                    "pageNumber": pageNumber,
                    "pageSize": pageSize
                ],
                cancelToken: cancelToken,
                completion: completion
            )
        }
    
    static func postIsMenuLiked(menuID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
            networkRequest(
                urlStr: MenuDetailAddress.postIsMenuLiked(menuID).url,
                method: .post,
                data: nil,
                model: Bool.self,
                completion: completion
            )
        }
    
    static func postIsReviewLiked(reviewID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
            networkRequest(
                urlStr: MenuDetailAddress.postIsReviewLiked(reviewID).url,
                method: .post,
                data: nil,
                model: Bool.self,
                completion: completion
            )
        }
}
