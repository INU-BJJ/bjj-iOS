//
//  FCMPath.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/28/26.
//

enum FCMPath {
    case registerFCMToken
    
    var url: String {
        switch self {
        case .registerFCMToken:
            return "device-tokens"
        }
    }
}
