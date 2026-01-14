//
//  AlertType.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/14/25.
//

import Foundation

enum AlertType {
    case success
    case failure
}

extension AlertType {
    var imageName: String {
        switch self {
        case .success:
            return "AlertSuccess"
        case .failure: 
            return "AlertFailure"
        }
    }
}
