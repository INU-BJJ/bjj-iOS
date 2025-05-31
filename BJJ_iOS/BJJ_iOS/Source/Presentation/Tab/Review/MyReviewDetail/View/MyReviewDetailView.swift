//
//  MyReviewDetailView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

protocol MyReviewDetailDelegate: AnyObject {
    func didTapReviewImage(with reviewImages: [String])
}

final class MyReviewDetailView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MyReviewDetailDelegate?
    private var reviewImages: [String] = []
    private var hashTags: [String] = []
    
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
    
    private let reviewTextView = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
        $0.numberOfLines = 0
    }
    
    private lazy var reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createImageLayout()
    ).then {
        $0.register(MyReviewDetailImageCell.self, forCellWithReuseIdentifier: MyReviewDetailImageCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
    }
    
    private lazy var reviewHashTagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createHashTagLayout()
    ).then {
        $0.register(MyReviewDetailHashTagCell.self, forCellWithReuseIdentifier: MyReviewDetailHashTagCell.reuseIdentifier)
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
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
            reviewImageCollectionView,
            reviewHashTagCollectionView
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
            $0.width.equalTo(33)
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
            $0.centerX.equalToSuperview()
        }
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(293)
        }
        
        reviewHashTagCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(25)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMyDatailReview(with myReviewInfo: MyReviewDetailSection) {
        nicknameLabel.text = myReviewInfo.memberNickname
        reviewRatingView.configureReviewStar(reviewRating: myReviewInfo.reviewRating, type: .small)
        reviewDateLabel.text = myReviewInfo.reviewCreatedDate
        reviewLikeCountLabel.text = String(myReviewInfo.reviewLikedCount)
        reviewTextView.text = myReviewInfo.reviewComment
        reviewImages = myReviewInfo.reviewImages
        hashTags = [myReviewInfo.mainMenuName, myReviewInfo.subMenuName]
        
        reviewImageCollectionView.reloadData()
        reviewHashTagCollectionView.reloadData()
        
        // TODO: 더 좋은 방법 생각하기
        if reviewImages.isEmpty {
            reviewImageCollectionView.removeFromSuperview()
        } else {
            if reviewImageCollectionView.superview == nil {
                myReviewStackView.addArrangedSubview(reviewImageCollectionView)
            }
        }
    }
    
    // MARK: - Create Layout
    
    private func createImageLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // TODO: absolute 없애기
            let absoluteItemWidth: CGFloat
            let absoluteGroupWidth: CGFloat
            
            switch self.reviewImages.count {
            case 1:
                absoluteItemWidth = 353
                absoluteGroupWidth = 353
            case 2:
                absoluteItemWidth = 175.5
                absoluteGroupWidth = 353
            case 3:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 165
                absoluteGroupWidth = 499
            case 4:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 165
                absoluteGroupWidth = 666
            default:
//                absoluteItemWidth = 1.0
                absoluteItemWidth = 353
                absoluteGroupWidth = 353
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(absoluteItemWidth), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(absoluteGroupWidth), heightDimension: .absolute(293))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
    
    private func createHashTagLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .estimated(25))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
}

extension MyReviewDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == reviewImageCollectionView {
            return reviewImages.count
        } else {
            return hashTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == reviewImageCollectionView {
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewDetailHashTagCell.reuseIdentifier, for: indexPath) as! MyReviewDetailHashTagCell
            // TODO: 하이라이트 라벨 수정
//            let isHighlighted = (indexPath.row == 0)
            let isHighlighted = true
            cell.configureHashTag(with: hashTags[indexPath.row], isHighlighted: isHighlighted)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == reviewImageCollectionView {
            delegate?.didTapReviewImage(with: reviewImages)
        }
    }
}
