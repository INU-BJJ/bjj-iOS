//
//  ReUseIdentifying.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/24/25.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
