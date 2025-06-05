//
//  MenuReviewInfoView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 5/25/25.
//

import UIKit
import SnapKit
import Then

final class MenuReviewInfoView: UIView {
    
    // MARK: - Properties
    
    private var isReviewLiked = false
    
    // MARK: - UI Components
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = .customColor(.lightGray)
        $0.layer.cornerRadius = 20.5
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let reviewRatingView = ReviewHorizontalView()
    
    private let reviewDateLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 13, color: .darkGray)
    }
    
    private let reviewLikeButton = UIButton().then {
        $0.setImage(UIImage(named: "Like")?.resize(to: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private let reviewLikeCountLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 11, color: .black)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setView() {
        backgroundColor = .white
    }
    
    // MARK: - Reset UI
    
    func resetUI() {
        nicknameLabel.text = ""
        reviewDateLabel.text = ""
        reviewRatingView.configureReviewStar(reviewRating: 0, type: .small)
        reviewLikeButton.setImage(UIImage(named: "Like")?.resize(to: CGSize(width: 17, height: 17)), for: .normal)
        reviewLikeCountLabel.text = ""
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            profileImage,
            nicknameLabel,
            reviewRatingView,
            reviewDateLabel,
            reviewLikeButton,
            reviewLikeCountLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(41)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top).inset(1)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        reviewRatingView.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.bottom.equalTo(profileImage.snp.bottom).inset(3.4)
        }
        
        reviewDateLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewRatingView.snp.trailing).offset(10)
            $0.centerY.equalTo(reviewRatingView)
        }
        
        reviewLikeButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top).offset(4)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        reviewLikeCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.bottom).inset(4)
            $0.centerX.equalTo(reviewLikeButton)
        }
    }
    
    // MARK: - Set UI
    
    func setUI(with menuReview: MenuDetailModel) {
        nicknameLabel.text = menuReview.memberNickname
        reviewRatingView.configureReviewStar(reviewRating: menuReview.reviewRating, type: .small)
        reviewDateLabel.text = menuReview.reviewCreatedDate
        reviewLikeCountLabel.text = "\(menuReview.reviewLikedCount)"
    }
    
    // MARK: - Set isReviewLiked
    
    func setIsReviewLiked(isReviewLiked: Bool) {
        self.isReviewLiked = isReviewLiked
    }
}
