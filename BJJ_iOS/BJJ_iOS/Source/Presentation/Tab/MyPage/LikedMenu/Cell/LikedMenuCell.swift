//
//  LikedMenuCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then

final class LikedMenuCell: BaseCollectionViewCell<LikedMenuSection> {
    
    // MARK: - UI Components
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        contentView.setBorder(color: .B_9_B_9_B_9, width: 0.5)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            menuNameLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        menuNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: LikedMenuSection) {
        menuNameLabel.text = data.menuName
    }
}
