//
//  HomeModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 12/26/24.
//

import Foundation

struct HomeMenuInfo: Hashable, Codable {
    let todayDietID: Int
    let price: String
    let kcal: String
    let date: String
    let menuPairID: Int
    let mainMenuID: Int
    let mainMenuName: String
    let subMenuID: Int
    let restMenu: String?
    let cafeteriaName: String
    let cafeteriaCorner: String
    let reviewCount: Int
    let reviewRatingAverage: Double
    let reviewImageName: String?
    let likedMenu: Bool
    
    enum CodingKeys: String, CodingKey {
        case todayDietID = "todayDietId"
        case price
        case kcal
        case date
        case menuPairID = "menuPairId"
        case mainMenuID = "mainMenuId"
        case mainMenuName
        case subMenuID = "subMenuId"
        case restMenu
        case cafeteriaName
        case cafeteriaCorner
        case reviewCount
        case reviewRatingAverage
        case reviewImageName
        case likedMenu
    }
}
