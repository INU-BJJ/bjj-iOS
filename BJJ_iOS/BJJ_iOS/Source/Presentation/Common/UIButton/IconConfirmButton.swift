//
//  IconConfirmButton.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/12/26.
//

import UIKit
import SnapKit
import Then

final class IconConfirmButton: BaseButton {

    // MARK: - UI Components

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let title = UILabel()
    
    // MARK: - Init
    
    init(
        icon: ImageAsset,
        text: String,
        titleColor: Colors = .black,
        backgroundColor: UIColor,
        font: Fonts = .pretendard_medium,
        size: CGFloat = 15
    ) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        setCornerRadius(radius: 10)
        
        iconImageView.setImage(icon)
        title.setLabelUI(text, font: font, size: size, color: titleColor)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            iconImageView,
            title
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
