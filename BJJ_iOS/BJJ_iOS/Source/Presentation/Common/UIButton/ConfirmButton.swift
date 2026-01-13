//
//  ConfirmButton.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import UIKit

final class ConfirmButton: UIButton {
    
    // MARK: - Init
    
    init(
        title: String,
        titleColor: UIColor = .white,
        backgroundColor: UIColor = .customColor(.mainColor),
        font: UIFont = .customFont(.pretendard_semibold, 15)
    ) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor
        setCornerRadius(radius: 11)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    func setUI(isEnabled: Bool) {
        self.isEnabled = isEnabled
        backgroundColor = isEnabled ? .customColor(.mainColor) : .B_9_B_9_B_9
    }
}
