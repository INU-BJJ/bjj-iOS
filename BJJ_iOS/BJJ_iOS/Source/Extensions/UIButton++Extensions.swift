//
//  UIButton++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit

enum ConfirmButtonType {
    case submitReview
    case startAfterSignUp
}

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
    
    func makeConfirmButton(type: ConfirmButtonType) -> UIButton {
        let button = UIButton()
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .customFont(.pretendard_medium, 15)
        button.layer.cornerRadius = 11
        button.backgroundColor = .customColor(.midGray)
        
        switch type {
        case .submitReview:
            button.setTitle("작성 완료", for: .normal)
            
        case .startAfterSignUp:
            button.setTitle("밥점줘 시작하기", for: .normal)
        }
        
        return button
    }
}



