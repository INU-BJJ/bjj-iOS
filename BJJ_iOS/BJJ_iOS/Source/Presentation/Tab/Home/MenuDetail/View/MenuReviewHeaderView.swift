//
//  MenuReviewHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "MenuReviewHeaderView"
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("리뷰", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let reviewCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .darkGray)
    }
    
    private let reviewRatingView = HomeMenuRatingView(rating: 4.2)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            titleLabel,
            reviewCountLabel,
            reviewRatingView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(1)
            $0.centerY.equalTo(titleLabel)
        }
        
        reviewRatingView.snp.makeConstraints {
            $0.leading.equalTo(reviewCountLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(titleLabel)
        }
    }
}

