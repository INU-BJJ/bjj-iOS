//
//  MenuReviewListCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 5/24/25.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var reviewImages: [String] = []
    private var hashTags: [String] = []
    private var isHashTagsHighlighted: [Bool] = []
    
    // MARK: - UI Components
    
    private let reviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    private let menuReviewInfoView = MenuReviewInfoView()
    
    private let reviewCommentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private lazy var reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(MenuReviewImageCell.self, forCellWithReuseIdentifier: MenuReviewImageCell.reuseIdentifier)
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
    }
    
    private lazy var reviewHashTagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createHashTagLayout()
    ).then {
        $0.register(MenuReviewHashTagCell.self, forCellWithReuseIdentifier: MenuReviewHashTagCell.reuseIdentifier)
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
    }
    
    private let menuReviewSeparatingView = MenuReviewSeparatingView()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reviewImages = []
        hashTags = []
        isHashTagsHighlighted = []
        
        reviewImageCollectionView.isHidden = false
        reviewImageCollectionView.snp.updateConstraints {
            $0.height.equalTo(270)
        }
        
        reviewHashTagCollectionView.isHidden = false
        reviewHashTagCollectionView.snp.updateConstraints {
            $0.height.equalTo(25)
        }
        
        reviewCommentLabel.text = ""
        menuReviewInfoView.resetUI()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            reviewStackView,
            menuReviewSeparatingView
        ].forEach(contentView.addSubview)
        
        [
            menuReviewInfoView,
            reviewCommentLabel,
            reviewImageCollectionView,
            reviewHashTagCollectionView
        ].forEach(reviewStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        reviewStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(31.5)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        menuReviewInfoView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        reviewCommentLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(270)
        }
        
        reviewHashTagCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        menuReviewSeparatingView.snp.makeConstraints {
            $0.width.bottom.equalToSuperview()
            $0.height.equalTo(7)
        }
    }
    
    // MARK: - Configure Cell
    
    func configure(with menuReview: MenuDetailModel) {
        self.reviewImages = menuReview.reviewImage ?? []
        
        let reviewImageCount = menuReview.reviewImage?.count ?? 0
        let flowLayout = createReviewImageLayout(reviewImageCount: reviewImageCount)
        
        menuReviewInfoView.setUI(with: menuReview)
        reviewCommentLabel.text = menuReview.reviewComment
        reviewImageCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        if reviewImageCount == 0 {
            reviewImageCollectionView.isHidden = true
            reviewImageCollectionView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            reviewImageCollectionView.isHidden = false
            reviewImageCollectionView.snp.updateConstraints {
                $0.height.equalTo(270)
            }
        }
        
        DispatchQueue.main.async {
            self.reviewImageCollectionView.reloadData()
        }
    }
    
    func bindHashTagData(hashTags: [String], isHighlighted: [Bool]) {
        self.hashTags = hashTags
        self.isHashTagsHighlighted = isHighlighted
        
        DispatchQueue.main.async {
            self.reviewHashTagCollectionView.reloadData()
        }
    }
    
    // MARK: - Create FlowLayout
    
    func createReviewImageLayout(reviewImageCount: Int) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
        switch reviewImageCount {
        case 1:
            layout.itemSize = CGSize(width: 330, height: 270)
        case 2:
            layout.itemSize = CGSize(width: 163, height: 270)
        case 3:
            layout.itemSize = CGSize(width: 150, height: 270)
        case 4:
            layout.itemSize = CGSize(width: 150, height: 270)
        default:
            layout.itemSize = CGSize(width: 330, height: 270)
        }
        
        return layout
    }
    
    private func createHashTagLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = CGSize(width: 80, height: 25)
        
        return layout
    }
}

extension MenuReviewListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewImageCollectionView {
            return reviewImages.count
        } else {
            return hashTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == reviewImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewImageCell.reuseIdentifier, for: indexPath) as! MenuReviewImageCell
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewHashTagCell.reuseIdentifier, for: indexPath) as! MenuReviewHashTagCell

            cell.configureHashTag(
                with: hashTags[indexPath.item],
                isHighlighted: isHashTagsHighlighted[indexPath.item]
            )
            return cell
        }
    }
}
