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
    var reviewLikedCount: Int
    let reviewCreatedDate: String
    let mainMenuName: String
    let subMenuName: String
    let memberNickname: String
    let memberImage: String
    let isOwned: Bool
    var isMemberLikedReview: Bool
}
