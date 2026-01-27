//
//  UserDefaultsManager.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/27/26.
//

import Foundation

final class UserDefaultsManager {
    
    // MARK: - Key

    enum UserDefaultsKey: String {
        case didRequestNotificationPermission = "DidRequestNotificationPermission"
    }
    
    // MARK: - Init
    
    static let shared = UserDefaultsManager()
    private init() { }
    
    // MARK: - Save
    
    func save<T>(value: T, key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    // MARK: - Read
    
    func readBool(_ key: UserDefaultsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    // MARK: - Delete
    
    func delete(_ key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
