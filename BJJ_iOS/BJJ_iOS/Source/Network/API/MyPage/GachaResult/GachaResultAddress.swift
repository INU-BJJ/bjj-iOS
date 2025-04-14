//
//  GachaResultAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation

enum GachaResultAddress {
    case postItemGacha
    
    var url: String {
        switch self {
        case .postItemGacha:
            return "items"
        }
    }
}
