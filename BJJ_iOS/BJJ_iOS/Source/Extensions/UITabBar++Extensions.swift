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
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3.7)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3.7)
        
        self.tintColor = .customColor(.mainColor)
        self.scrollEdgeAppearance = appearance
        
        // 그림자 효과
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
    }
}
