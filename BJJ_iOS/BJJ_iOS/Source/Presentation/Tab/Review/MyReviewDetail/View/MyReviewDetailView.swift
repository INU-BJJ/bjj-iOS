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
    
    // MARK: - Properties
    
    private var reviewImages: [String] = []
    
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
    
    private lazy var reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MyReviewDetailImageCell.self, forCellWithReuseIdentifier: MyReviewDetailImageCell.reuseIdentifier)
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
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
            reviewTextView,
            reviewImageCollectionView
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
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            // TODO: 높이 질문하기
            $0.height.equalTo(250)
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // TODO: absolute 없애기
            // TODO: 너비가 이전에 쓰던 것과 달라져서 업데이트 하기
            let absoluteItemWidth: CGFloat
            let absoluteGroupWidth: CGFloat
            
            switch self.reviewImages.count {
            case 1:
                absoluteItemWidth = 301
                absoluteGroupWidth = 301
            case 2:
                absoluteItemWidth = 149.5
                absoluteGroupWidth = 301
            case 3:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 426.16
            case 4:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 568.88
            case 5:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 711.59
            default:
//                absoluteItemWidth = 1.0
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 301
            }
            
            // TODO: absolute 없애기
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(absoluteItemWidth), heightDimension: .absolute(250))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(absoluteGroupWidth), heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
}

extension MyReviewDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewDetailImageCell.reuseIdentifier, for: indexPath) as! MyReviewDetailImageCell
        var cornerStyle: UIRectCorner = []
        
        if reviewImages.count > 1 {
            if indexPath.row == 0 {
                cornerStyle = [.topLeft, .bottomLeft]
            } else if indexPath.row == reviewImages.count - 1 {
                cornerStyle = [.topRight, .bottomRight]
            }
        } else {
            cornerStyle = [.allCorners]
        }

        cell.configureReviewImageCell(with: reviewImages[indexPath.row], cornerStyle: cornerStyle)
        
        return cell
    }
}
