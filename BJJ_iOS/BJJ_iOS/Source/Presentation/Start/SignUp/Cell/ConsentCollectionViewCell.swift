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
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            checkBoxIcon
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        checkBoxIcon.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: ConsentModel) {
        checkBoxIcon.setImage(data.isAgreed ? .smallBorderCheckBox : .smallEmptyBorderCheckBox)
    }
}
