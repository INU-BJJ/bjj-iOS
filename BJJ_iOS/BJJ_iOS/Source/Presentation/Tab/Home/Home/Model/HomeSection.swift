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
    let price: String
    let menuRating: Double
    let cafeteria: String
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

extension HomeMenuModel {
    static let studentCafeteriaMenu = [
        HomeMenuModel(text: "차슈 덮밥1", image: "MenuImage1", price: "7,500원", menuRating: 4.4, cafeteria: "학생식당 2코너"),
        HomeMenuModel(text: "우삼겹떡볶이*핫도그1", image: "MenuImage2", price: "5,500원", menuRating: 4.2, cafeteria: "학생식당 2코너"),
        HomeMenuModel(text: "짜장면*짬뽕국1", image: "MenuImage2", price: "7,500원", menuRating: 4.3, cafeteria: "학생식당 2코너")
    ]
    
    static let staffCafeteriaMenu = [
        HomeMenuModel(text: "차슈 덮밥2", image: "MenuImage1", price: "7,500원", menuRating: 4.4, cafeteria: "인천대 교직원식당"),
        HomeMenuModel(text: "우삼겹떡볶이*핫도그2", image: "MenuImage2", price: "5,500원", menuRating: 4.2, cafeteria: "인천대 교직원식당"),
        HomeMenuModel(text: "짜장면*짬뽕국2", image: "MenuImage2", price: "7,500원", menuRating: 4.3, cafeteria: "인천대 교직원식당")
    ]
    
    static let dormitoryCafeteriaMenu = [
        HomeMenuModel(text: "차슈 덮밥3", image: "MenuImage1", price: "7,500원", menuRating: 4.4, cafeteria: "제1 기숙사 식당"),
        HomeMenuModel(text: "우삼겹떡볶이*핫도그3", image: "MenuImage2", price: "5,500원", menuRating: 4.2, cafeteria: "제1 기숙사 식당"),
        HomeMenuModel(text: "짜장면*짬뽕국3", image: "MenuImage2", price: "7,500원", menuRating: 4.3, cafeteria: "제1 기숙사 식당")
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


