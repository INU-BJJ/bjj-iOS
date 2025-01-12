//
//  MenuDetailModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/3/25.
//

import Foundation

struct MenuDetailReviewInfo: Hashable, Codable {
    let reviewID: Int
    let comment: String
    let reviewRating: Int
    let reviewImage: String
    let reviewLikeCount: Int
    let reviewCreatedDate: String
    let menuPairID: Int
    let mainMenuName: String
    let subMenuName: String
    let memberID: Int
    let memberNickname: String
    let memberImage: String
    let isMemberLikedReview: Bool
    
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
        case isMemberLikedReview = "liked"
    }
}

struct MenuDetailReview: Hashable, Codable {
    let reviewList: [MenuDetailReviewInfo]
    let isLastPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case reviewList = "reviewDetailList"
        case isLastPage = "lastPage"
    }
}

struct MenuDetailReviewImage: Hashable, Codable {
    let reviewImageDetailList: [MenuDetailImage]
    let isLastPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case reviewImageDetailList
        case isLastPage = "lastPage"
    }
}

struct MenuDetailImage: Hashable, Codable {
    let reviewID: Int
    let reviewImage: String
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case reviewImage = "imageName"
    }
}
