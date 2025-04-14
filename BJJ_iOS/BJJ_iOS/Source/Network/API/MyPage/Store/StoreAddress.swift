//
//  StoreAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation

enum StoreAddress {
    case fetchAllItems
    
    var url: String {
        switch self {
        case .fetchAllItems:
            return "items"
        }
    }
}
