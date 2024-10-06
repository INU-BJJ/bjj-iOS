//
//  HomeSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import Foundation

struct HomeModel {
    static let cafeteria = ["인천대 학생식당", "인천대 교직원식당", "제1기숙사식당"]
    
    static let menu = [
        ["차슈 덮밥", "우삼겹떡볶이*핫도그", "짜장면*짬뽕국"],
        ["d 메뉴", "e 메뉴", "f 메뉴"],
        ["g 메뉴", "h 메뉴", "i 메뉴"]
    ]
}

enum HomeSection: Hashable {
    case cafeteriaCategory
    case menuCategory
}

enum HomeItem: Hashable {
    case cafeteria(String)
    case menu(String)
}


