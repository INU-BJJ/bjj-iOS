//
//  ReviewModalModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/18/25.
//

import Foundation

struct BestReviewModel: Hashable, Codable {
    let reviewID: Int
    let comment: String
    let reviewRating: Int
    let reviewImages: [String]
    let reviewLikeCount: Int
    let reviewCreatedDate: String
    let menuPairID: Int
    let mainMenuName: String
    let subMenuName: String
    let memberID: Int
    let memberNickname: String
    let memberImage: String?
    let isOwned: Bool
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case comment
        case reviewRating = "rating"
        case reviewImages = "imageNames"
        case reviewLikeCount = "likeCount"
        case reviewCreatedDate = "createdDate"
        case menuPairID = "menuPairId"
        case mainMenuName
        case subMenuName
        case memberID = "memberId"
        case memberNickname
        case memberImage = "memberImageName"
        case isOwned = "owned"
        case isLiked = "liked"
    }
}
