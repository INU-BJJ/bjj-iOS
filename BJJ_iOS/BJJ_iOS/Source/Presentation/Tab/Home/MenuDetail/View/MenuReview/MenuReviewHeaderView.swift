//
//  MenuReviewHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewHeaderView: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("리뷰", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let reviewCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .darkGray)
    }
    
    private let reviewRatingView = MenuRatingView()
    
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
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(1)
            $0.centerY.equalTo(titleLabel)
        }
        
        reviewRatingView.snp.makeConstraints {
            $0.leading.equalTo(reviewCountLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(titleLabel)
            $0.width.equalTo(53)
            $0.height.equalTo(21)
        }
    }
    
    // MARK: - Configure HeaderView
    
    func configureHeaderView(reviewCount: Int, reviewRating: Double) {
        reviewCountLabel.text = "(\(reviewCount))"
        reviewRatingView.configureRatingLabel(with: reviewRating)
    }
}

