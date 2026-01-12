//
//  IconConfirmButton.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/12/26.
//

import UIKit

final class IconConfirmButton: UIButton {
    
    // MARK: - Init
    
    init(
        icon: ImageAsset,
        title: String,
        titleColor: UIColor = .black,
        backgroundColor: UIColor,
        font: UIFont = .customFont(.pretendard_medium, 15)
    ) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setImage(UIImage(named: icon.name), for: .normal)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor
        setCornerRadius(radius: 10)
        
        // 아이콘과 텍스트 간격 설정
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 4)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -2)
        
        // 아이콘 색상 설정
        tintColor = titleColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
