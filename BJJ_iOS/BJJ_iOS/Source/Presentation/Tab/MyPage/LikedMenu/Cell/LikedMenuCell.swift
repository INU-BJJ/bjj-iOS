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
    
    private let testMenuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            testMenuNameLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        testMenuNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: LikedMenuSection) {
        testMenuNameLabel.text = data.menuName
    }
}
