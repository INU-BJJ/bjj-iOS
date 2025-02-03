//
//  UIButton++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit

extension UIButton {
    
    func makeFloatingButton() -> UIButton {
        let button = UIButton()
        
        // 버튼 기본 설정
        button.layer.cornerRadius = 28.44
        
        // 버튼 이미지 설정
        button.setImage(UIImage(named: "FloatingButton"), for: .normal)
        
        // TODO: 버튼 그림자 설정
        
        return button
    }
}



