//
//  RankingModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import Foundation

struct MenuRankingInfo: Hashable, Codable {
    let menuID: Int
    let menuName: String
    let menuRating: Double
    let cafeteriaName: String
    let cafeteriaCorner: String
    let bestReviewID: Int
    let reviewImage: String?
    let updatedDate: String
    
    enum CodingKeys: String, CodingKey {
        case menuID = "menuId"
        case menuName
        case menuRating
        case cafeteriaName
        case cafeteriaCorner
        case bestReviewID = "bestReviewId"
        case reviewImage = "reviewImageName"
        case updatedDate = "updatedAt"
    }
}

struct MenuRankingList: Hashable, Codable {
    let menuRankingList: [MenuRankingInfo]
    let isLastPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case menuRankingList = "menuRankingDetailList"
        case isLastPage = "lastPage"
    }
}
