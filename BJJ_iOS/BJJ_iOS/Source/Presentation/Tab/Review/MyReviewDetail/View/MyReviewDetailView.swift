//
//  MyReviewDetailView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewDetailView: UIView {
    
    // MARK: - UI Components
    
    private let myReviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    private let myInfoTotalView = UIView()
    
    private let myInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let myRatingDateView = UIView()
    
    private let myLikedView = UIView()
    
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
        $0.setLabelUI("2024.08.20", font: .pretendard, size: 13, color: .darkGray)
    }
    
    private let reviewLikeButton = UIButton().then {
        $0.setImage(UIImage(named: "Like")?.resize(to: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private let reviewLikeCountLabel = UILabel().then {
        $0.setLabelUI("15004", font: .pretendard, size: 11, color: .black)
    }
    
    // TODO: 서버 데이터 연결하기
    private let reviewTextView = UITextView().then {
        $0.textColor = .black
        $0.text = "핫도그는 냉동인데\n떡볶이는 맛있음\n맛도 있고 가격도 착해서 떡볶이 땡길 때 추천"
        $0.font = .customFont(.pretendard_medium, 13)
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets.zero
        $0.textContainer.lineFragmentPadding = 0
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
        
        // TODO: configure 함수로 빼기
        reviewRatingView.configureReviewStar(reviewRating: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            myReviewStackView
        ].forEach(addSubview)
        
        [
            myInfoTotalView,
            reviewTextView
        ].forEach(myReviewStackView.addArrangedSubview)
        
        [
            profileImage,
            myInfoStackView,
            myLikedView
        ].forEach(myInfoTotalView.addSubview)
        
        [
            nicknameLabel,
            myRatingDateView
        ].forEach(myInfoStackView.addArrangedSubview)
        
        [
            reviewRatingView,
            reviewDateLabel
        ].forEach(myRatingDateView.addSubview)
        
        [
            reviewLikeButton,
            reviewLikeCountLabel
        ].forEach(myLikedView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        myReviewStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myInfoTotalView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(41)
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        myInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview().inset(2.5)
        }
        
        // TODO: 따봉 View 위치 점검
        myLikedView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        reviewRatingView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2.4)
        }
        
        reviewDateLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewRatingView.snp.trailing).offset(10)
            $0.centerY.equalTo(reviewRatingView)
        }
        
        reviewLikeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        reviewLikeCountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
