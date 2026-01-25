//
//  HomeAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 12/26/24.
//

import Foundation

enum HomeAddress {
    case fetchAllMenuInfo
    case fetchCafeteriaInfo(String)
    case fetchBannerList
    
    var url: String {
        switch self {
        case .fetchAllMenuInfo:
            return "today-diets"
        case .fetchCafeteriaInfo(let cafeteriaName):
            return "cafeterias/\(cafeteriaName)"
        case .fetchBannerList:
            return "banners"
        }
    }
}
