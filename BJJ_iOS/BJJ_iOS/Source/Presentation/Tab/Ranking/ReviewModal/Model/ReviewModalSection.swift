//
//  ReviewModalSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/18/25.
//

import Foundation

struct BestReviewSection: Hashable {
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
}
