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
    
    // UIButton 설정
    func setButton(title: String, font: Fonts, size: CGFloat, color: UIColor) {
        var config = UIButton.Configuration.plain()
        
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.customFont(font, size),
                .foregroundColor: color
            ])
        )
        
        configuration = config
    }
    
    // UIButton 아이콘과 타이틀 설정
    func setButtonWithIcon(
        title: String,
        font: Fonts,
        size: CGFloat,
        textColor: UIColor,
        icon: ImageAsset,
        iconPadding: CGFloat,
        backgroundColor: UIColor
    ) {
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = backgroundColor
        config.image = UIImage(named: icon.name)?.resize(to: CGSize(width: 26, height: 26))
        config.imagePlacement = .leading
        config.imagePadding = iconPadding
        config.baseForegroundColor = textColor
        
        var titleAttr = AttributedString(title)
        titleAttr.font = UIFont.customFont(font, size)
        config.attributedTitle = titleAttr
        
        configuration = config
    }
}
