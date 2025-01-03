//
//  HomeAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 12/26/24.
//

import Foundation

enum HomeAddress {
    case fetchAllMenuInfo
    
    var url: String {
        switch self {
        case .fetchAllMenuInfo:
            return "today-diets"
        }
    }
}
