//
//  HomeSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import Foundation

struct HomeCafeteriaModel: Hashable {
    let text: String
}

struct HomeMenuModel: Hashable {
    let menuName: String
    let menuImage: String?
    let menuPrice: String
    let menuRating: Double
    let cafeteriaCorner: String
    let isLikedMenu: Bool
    let restMenu: [String]?
    let reviewCount: Int
    let menuPairID: Int
}

extension HomeCafeteriaModel {
    static let cafeteria = [
        HomeCafeteriaModel(text: "인천대 학생식당"),
        HomeCafeteriaModel(text: "2호관 식당"),
        HomeCafeteriaModel(text: "제1기숙사식당"),
        HomeCafeteriaModel(text: "27호관식당"),
        HomeCafeteriaModel(text: "사범대식당")
    ]
}

enum HomeSection: Hashable, CaseIterable {
    case cafeteriaCategory
    case menuCategory
}

enum HomeItem: Hashable {
    case cafeteria(String)
    case menu(String)
}


