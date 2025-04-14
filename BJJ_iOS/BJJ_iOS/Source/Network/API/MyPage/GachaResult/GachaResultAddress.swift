//
//  GachaResultAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation

enum GachaResultAddress {
    case postItemGacha
    case patchItem(Int)
    
    var url: String {
        switch self {
        case .postItemGacha:
            return "items"
        case .patchItem(let itemID):
            return "items/\(itemID)"
        }
    }
}
