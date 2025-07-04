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
    let cafeteriaName: String
    let cafeteriaCorner: String
    var isLikedMenu: Bool
    let restMenu: [String]?
    let reviewCount: Int
    let menuPairID: Int
    let mainMenuID: Int
    let subMenuID: Int?
}

extension HomeCafeteriaModel {
    static let cafeteria = [
        HomeCafeteriaModel(text: "학생식당"),
        HomeCafeteriaModel(text: "2호관식당"),
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

struct HomeCafeteriaInfoSection: Hashable {
    let cafeteriaName: String
    let cafeteriaLocation: String
    let serviceTime: CafeteriaServiceTime
    let cafeteriaMapImage: String
}

struct CafeteriaServiceTime: Hashable {
    let serviceHourTitle: String
    let weekDaysServiceTime: [String]
    let weekendsServiceTime: [String]
}
