//
//  MenuItem.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import Foundation

struct MenuDetailModel: Hashable {
    let reviewID: Int
    let reviewComment: String
    let reviewRating: Int
    let reviewImage: [String]?
    let reviewLikedCount: Int
    let reviewCreatedDate: String
    let mainMenuName: String
    let subMenuName: String
    let mainMenuID: Int
    let subMenuID: Int
    let memberNickname: String
    let memberImage: String
    let isOwned: Bool
    let isMemberLikedReview: Bool
}
