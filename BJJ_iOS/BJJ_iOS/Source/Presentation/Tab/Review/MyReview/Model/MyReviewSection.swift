//
//  MyReviewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/2/25.
//

import Foundation

struct MyReviewSection: Hashable {
    let reviewID: Int
    let reviewComment: String
    let reviewRating: Int
    let reviewImages: [String]
    let reviewLikedCount: Int
    let reviewCreatedDate: String
    let menuPairID: Int
    let mainMenuName: String
    let subMenuName: String
    let memberID: Int
    let memberNickName: String
    let memberImageName: String?
}
