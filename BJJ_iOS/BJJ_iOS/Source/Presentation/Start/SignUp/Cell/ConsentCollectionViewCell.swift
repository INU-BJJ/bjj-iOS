//
//  ConsentCollectionViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import UIKit
import SnapKit
import Then

final class ConsentCollectionViewCell: BaseCollectionViewCell<ConsentModel> {
    
    // MARK: - Components
    
    private let checkBoxIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let consentTitleLabel = UILabel().then {
        $0.setLabel("", font: .pretendard, size: 13, color: .black)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            checkBoxIcon,
            consentTitleLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        checkBoxIcon.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        consentTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkBoxIcon.snp.trailing).offset(8)
            // TODO: 네비게이팅 아이콘 간격 차이로 수정
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: ConsentModel) {
        checkBoxIcon.setImage(data.isAgreed ? .smallBorderCheckBox : .smallEmptyBorderCheckBox)
        consentTitleLabel.text = data.title
    }
}
