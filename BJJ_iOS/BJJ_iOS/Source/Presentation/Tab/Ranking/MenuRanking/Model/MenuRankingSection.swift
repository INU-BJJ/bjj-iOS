//
//  MenuRankingSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/18/25.
//

import Foundation

struct MenuRankingSection: Hashable {
    let menuID: Int
    let menuName: String
    let menuRating: Double
    let cafeteriaName: String
    let cafeteriaCorner: String
    let bestReviewID: Int
    let reviewImage: String
    let updatedDate: String
}

struct MenuRankingListSection: Hashable {
    let menuRankingList: [MenuRankingSection]
    let isLastPage: Bool
}
