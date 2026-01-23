//
//  SettingTableViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/21/26.
//

import UIKit
import SnapKit
import Then

final class SettingTableViewCell: BaseTableViewCell<SettingMenu> {
    
    // MARK: Components
    
    private let titleLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        selectionStyle = .none
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: SettingMenu) {
        titleLabel.text = data.title
    }
}
