//
//  CafeteriaMyReviewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/5/25.
//

import Foundation

// TODO: 모델 재사용 검토 (MyReviewModel과 같음)
struct CafeteriaMyReviewInfo: Hashable, Codable {
    let reviewID: Int
    let comment: String
    let reviewRating: Int
    let reviewImage: [String]?
    let reviewLikeCount: Int
    let reviewCreatedDate: String
    let menuPairID: Int
    let mainMenuName: String
    let subMenuName: String
    let memberID: Int
    let memberNickname: String
    let memberImage: String?
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case comment
        case reviewRating = "rating"
        case reviewImage = "imageNames"
        case reviewLikeCount = "likeCount"
        case reviewCreatedDate = "createdDate"
        case menuPairID = "menuPairId"
        case mainMenuName
        case subMenuName
        case memberID = "memberId"
        case memberNickname
        case memberImage = "memberImageName"
    }
}

struct CafeteriaMyReviewList: Hashable, Codable {
    let myReviewList: [MyReviewInfo]
    
    enum CodingKeys: String, CodingKey {
        case myReviewList = "myReviewDetailList"
    }
}
