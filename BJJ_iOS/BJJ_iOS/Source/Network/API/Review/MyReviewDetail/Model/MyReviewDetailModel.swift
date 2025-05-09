//
//  MyReviewDetailModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 5/8/25.
//

import Foundation

struct MyReviewDetailModel: Codable {
    let reviewID: Int
    let reviewComment: String
    let reviewRating: Int
    let reviewImages: [String]
    let reviewLikedCount: Int
    let reviewCreatedDate: String
    let menuPairID: Int
    let mainMenuID: Int
    let mainMenuName: String
    let subMenuID: Int
    let subMenuName: String
    let memberID: Int
    let memberNickname: String
    let memberImage: String?
    let isOwned: Bool
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case reviewComment = "comment"
        case reviewRating = "rating"
        case reviewImages = "imageNames"
        case reviewLikedCount = "likeCount"
        case reviewCreatedDate = "createdDate"
        case menuPairID = "menuPairId"
        case mainMenuID = "mainMenuId"
        case mainMenuName
        case subMenuID = "subMenuId"
        case subMenuName
        case memberID = "memberId"
        case memberNickname
        case memberImage = "memberImageName"
        case isOwned = "owned"
        case isLiked = "liked"
    }
}
