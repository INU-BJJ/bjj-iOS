//
//  KeychainManager.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import Foundation

class KeychainManager {
    
    static func create(token: String) {
        
        guard let data = token.data(using: .utf8) else {
            fatalError("토큰 직렬화 실패")
        }
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecValueData: data
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == errSecSuccess, "토큰 저장 실패")
    }
    
    static func read() -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var readData: AnyObject?
        let status = SecItemCopyMatching(query, &readData)

        if status == errSecSuccess, let data = readData as? Data {
            return String(data: data, encoding: .utf8)
        } else if status == errSecItemNotFound {
            // accessToken을 찾지 못한 경우 (회원 가입하기 이전 상황)
            return nil
        } else {
            assert(status == errSecSuccess, "토큰 읽기 실패")
            return nil
        }
    }
    
    static func delete() {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken"
        ]
        
        let status = SecItemDelete(query)
        
        if status == errSecItemNotFound {
            print("삭제 가능 토큰 없음")
        } else {
            assert(status == errSecSuccess, "토큰 삭제 실패")
        }
    }
}
