//
//  MemberAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import Foundation

enum MemberAddress {
    case fetchMemberInfo
    case deleteMemberInfo
    
    var url: String {
        switch self {
        case .fetchMemberInfo:
            return "members"
        case .deleteMemberInfo:
            return "members"
        }
    }
}
