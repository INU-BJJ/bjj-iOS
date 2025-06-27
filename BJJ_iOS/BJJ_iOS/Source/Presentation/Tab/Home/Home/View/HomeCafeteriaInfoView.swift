//
//  HomeCafeteriaInfoView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/26/25.
//

import UIKit
import SnapKit
import Then

final class HomeCafeteriaInfoView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("식당 정보", font: .pretendard_semibold, size: 18, color: .black)
    }
    
    // MARK: - LifeCycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {
        backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            titleLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
