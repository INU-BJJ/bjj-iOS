//
//  KeychainManager.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import Foundation

class KeychainManager {
    
    // MARK: - Key Type
    
    enum KeyType: String {
        case accessToken = "accessToken"
        case tempToken = "tempToken"
    }
    
    static func create(value: String, key: KeyType) {
        
        guard let data = value.data(using: .utf8) else {
            fatalError("값 직렬화 실패")
        }
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == errSecSuccess, "\(key.rawValue) 저장 실패")
    }
    
    // MARK: - Read
    
    static func read(key: KeyType) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
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
            assert(status == errSecSuccess, "\(key.rawValue) 읽기 실패")
            return nil
        }
    }
    
    static func readBool(key: KeyType) -> Bool {
        guard let value = read(key: key) else { return false }
        return value == "true"
    }
    
    // MARK: - Delete
    
    static func delete(key: KeyType) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query)
        
        if status == errSecItemNotFound {
            print("\(key.rawValue) 삭제 가능 항목 없음")
        } else {
            assert(status == errSecSuccess, "\(key.rawValue) 삭제 실패")
        }
    }
    
    /// 토큰 저장 유무 판별
    static func hasToken(type: KeyType) -> Bool {
        return read(key: type) != nil
    }
}
