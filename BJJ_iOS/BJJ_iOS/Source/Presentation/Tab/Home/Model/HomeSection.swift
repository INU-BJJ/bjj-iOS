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
    let text: String
    let image: String
}

extension HomeCafeteriaModel {
    static let cafeteria = [
        HomeCafeteriaModel(text: "인천대 학생식당"), 
        HomeCafeteriaModel(text: "인천대 교직원식당"),
        HomeCafeteriaModel(text: "제1기숙사식당")
    ]
}

extension HomeMenuModel {
//    static let menu = [
//        HomeMenuModel(text: "차슈 덮밥1", image: "MenuImage1"),
//        HomeMenuModel(text: "우삼겹떡볶이*핫도그1", image: "MenuImage2"),
//        HomeMenuModel(text: "짜장면*짬뽕국1", image: "MenuImage3"),
//        
//    ]
    static let studentCafeteriaMenu = [
        HomeMenuModel(text: "차슈 덮밥1", image: "MenuImage1"),
        HomeMenuModel(text: "우삼겹떡볶이*핫도그1", image: "MenuImage2"),
        HomeMenuModel(text: "짜장면*짬뽕국1", image: "MenuImage3")
    ]
    
    static let staffCafeteriaMenu = [
        HomeMenuModel(text: "차슈 덮밥2", image: "MenuImage1"),
        HomeMenuModel(text: "우삼겹떡볶이*핫도그2", image: "MenuImage2"),
        HomeMenuModel(text: "짜장면*짬뽕국2", image: "MenuImage3")
    ]
    
    static let dormitoryCafeteriaMenu = [
        HomeMenuModel(text: "차슈 덮밥3", image: "MenuImage1"),
        HomeMenuModel(text: "우삼겹떡볶이*핫도그3", image: "MenuImage2"),
        HomeMenuModel(text: "짜장면*짬뽕국3", image: "MenuImage3")
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


