//
//  MemberModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import Foundation

struct MemberInfoModel: Hashable, Codable {
    let nickname: String
    let email: String
    let provider: String
}
