//
//  UITabBar++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/15/24.
//

import UIKit

extension UITabBar {
    
    func setTabBar() {
        let appearance = UITabBarAppearance()
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_medium, 11),
            .foregroundColor: UIColor.customColor(.midGray)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_medium, 11),
            .foregroundColor: UIColor.customColor(.mainColor)
        ]
        
        appearance.shadowColor = nil
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        self.tintColor = .customColor(.mainColor)
        self.scrollEdgeAppearance = appearance
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
    }
}
