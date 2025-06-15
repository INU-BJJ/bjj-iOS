//
//  AlertType.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/14/25.
//

import Foundation

enum AlertType {
    case success(Kind)
    case failure(Kind)
    
    enum Kind {
        case nicknameEdit
    }
}

// TODO: 문구 수정

extension AlertType {
    var title: String {
        switch self {
        case .success(.nicknameEdit):
            return "[테스트] 닉네임 수정 성공"
        case .failure(.nicknameEdit):
            return "[테스트] 닉네임 수정 실패"
        }
    }
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
