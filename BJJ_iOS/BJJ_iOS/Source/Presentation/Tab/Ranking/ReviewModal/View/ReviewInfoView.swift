//
//  ReviewInfoView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class ReviewInfoView: UIView {
    
    // MARK: - UI Components
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = .customColor(.lightGray)
        $0.layer.cornerRadius = 20.5
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("떡볶이킬러나는최고야룰루", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let reviewRatingView = ReviewHorizontalView()
    
    private let reviewDateLabel = UILabel().then {
        $0.setLabelUI("2025.03.17", font: .pretendard, size: 13, color: .darkGray)
    }
    
    private let bestReviewLabel = UILabel().then {
        $0.setLabelUI("best review", font: .pretendard_medium, size: 11, color: .mainColor)
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor.customColor(.mainColor).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 9
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            profileImage,
            nicknameLabel,
            reviewRatingView,
            reviewDateLabel,
            bestReviewLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        profileImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(41)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3.5)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        reviewRatingView.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.bottom).inset(5.9)
            $0.leading.equalTo(nicknameLabel)
        }
        
        reviewDateLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewRatingView.snp.trailing).offset(10)
            $0.centerY.equalTo(reviewRatingView)
        }
        
        bestReviewLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(75)
            $0.height.equalTo(18)
        }
    }
    
    // MARK: - Set View
    
    private func setView() {
        reviewRatingView.configureReviewStar(reviewRating: 4, type: .small)
    }
}
