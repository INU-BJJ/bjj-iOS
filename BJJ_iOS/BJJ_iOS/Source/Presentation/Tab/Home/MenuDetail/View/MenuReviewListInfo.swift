//
//  MenuReviewListInfo.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListInfo: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuReviewListInfo"
//    private var reviewData: [asdfas] = []
    
    // MARK: - UI Components
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = .customColor(.lightGray)
        $0.layer.cornerRadius = 20.5
        $0.clipsToBounds = true
    }
    
    private let reviewListStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private let reviewListLeftStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let reviewListRightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private let reviewRatingDateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("떡볶이킬러나는최고야룰루", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let reviewRatingView = ReviewHorizontalView()
    
    private let reviewDateLabel = UILabel().then {
        $0.setLabelUI("2024.08.20", font: .pretendard, size: 13, color: .darkGray)
    }
    
    private let reviewLikeButton = UIButton().then {
        $0.setImage(UIImage(named: "Like")?.resize(to: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private let reviewLikeCountLabel = UILabel().then {
        $0.setLabelUI("0", font: .pretendard, size: 11, color: .black)
    }
    
    // MARK: - Life Cycle
    
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
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            profileImage,
            reviewListStackView
        ].forEach(contentView.addSubview)
        
        [
            reviewListLeftStackView,
            reviewListRightStackView
        ].forEach(reviewListStackView.addArrangedSubview)
        
        [
            nicknameLabel,
            reviewRatingDateStackView
        ].forEach(reviewListLeftStackView.addArrangedSubview)
        
        [
            reviewRatingView,
            reviewDateLabel
        ].forEach(reviewRatingDateStackView.addArrangedSubview)
        
        [
            reviewLikeButton,
            reviewLikeCountLabel
        ].forEach(reviewListRightStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(41)
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        reviewListStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }
}