//
//  MyReviewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/24/25.
//

import Foundation

struct MyReviewInfo: Hashable, Codable {
    let reviewID: Int
    let comment: String
    let reviewRating: Int
    let reviewImage: [String]
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

struct MyReviewList: Hashable, Codable {
    let myReviewList: [String: [MyReviewInfo]]
    
    enum CodingKeys: String, CodingKey {
        case myReviewList = "myReviewDetailList"
    }
}
