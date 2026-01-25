//
//  HomeTopView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeTopView: BaseView {
    
    // MARK: - Components
    
    private lazy var jumbotronLabel = UILabel().then {
        $0.setLabelUI("오늘의 인기 메뉴", font: .pretendard_semibold, size: 24, color: .black)
        $0.numberOfLines = 0
    }
    
    // MARK: - Set UI
        
    override func setUI() {
        backgroundColor = .customColor(.mainColor)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
         jumbotronLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        jumbotronLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.leading.equalToSuperview().offset(31)
            $0.bottom.equalToSuperview().offset(18)
        }
    }
}
