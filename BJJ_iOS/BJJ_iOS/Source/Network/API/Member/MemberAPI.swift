//
//  MemberAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import Foundation
import Alamofire

final class MemberAPI {
    static func fetchMemberInfo(completion: @escaping (Result<MemberInfoModel, Error>) -> Void) {
        networkRequest(
            urlStr: MemberAddress.fetchMemberInfo.url,
            method: .get,
            data: nil,
            model: MemberInfoModel.self,
            completion: completion
        )
    }
    
    static func deleteMemberInfo(completion: @escaping (Result<Empty, Error>) -> Void) {
        networkRequest(
            urlStr: MemberAddress.deleteMemberInfo.url,
            method: .delete,
            data: nil,
            model: Empty.self,
            completion: completion
        )
    }
}
