//
//  MyReviewDetailSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import Foundation

struct MyReviewDetailSection: Hashable {
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
}
