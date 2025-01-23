//
//  MenuItem.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import Foundation

struct MenuDetailModel: Hashable {
    let reviewComment: String
    let reviewRating: Int
    let reviewImage: [String]
    let reviewLikedCount: Int
    let reviewCreatedDate: String
    let mainMenuName: String
    let subMenuName: String
    let memberNickname: String
    let memberImage: String
    let isMemberLikedReview: Bool
}
