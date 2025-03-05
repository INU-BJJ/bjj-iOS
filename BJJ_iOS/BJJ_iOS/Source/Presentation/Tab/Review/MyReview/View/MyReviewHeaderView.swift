//
//  MyReviewHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewHeaderView: UITableViewHeaderFooterView, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let reviewMoreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 11)
        $0.setTitleColor(.customColor(.darkGray), for: .normal)
    }
    
    // MARK: - Initializer
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            cafeteriaNameLabel,
            reviewMoreButton
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        cafeteriaNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(40)
        }
        
        reviewMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(cafeteriaNameLabel)
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Configure HeaderView
    
    func configureMyReviewHeaderView(with cafeteriaName: String) {
        cafeteriaNameLabel.text = cafeteriaName
    }
    
    func setReviewMoreButtonVisibility(_ isVisible: Bool) {
        reviewMoreButton.isHidden = !isVisible
    }
}
