//
//  MenuReviewListContent.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListContent: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var reviewImages: [String] = []
    
    // MARK: - UI Components
    
    private let reviewContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 12
    }
    
    private let reviewContentTextView = UITextView().then {
        $0.textColor = .black
        $0.font = .customFont(.pretendard_medium, 13)
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets.zero
        $0.textContainer.lineFragmentPadding = 0
    }
    
    private lazy var reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MenuReviewImageCell.self, forCellWithReuseIdentifier: MenuReviewImageCell.reuseIdentifier)
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
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
            reviewContentTextView,
            reviewImageCollectionView
        ].forEach(reviewContentStackView.addArrangedSubview)
        
        contentView.addSubview(reviewContentStackView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewContentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // TODO: absolute 없애기
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
    
    // MARK: - Configure Cell
    
    func configureReviewListContent(with reviewList: MenuDetailModel) {
        reviewContentTextView.text = reviewList.reviewComment
        self.reviewImages = reviewList.reviewImage ?? []
        reviewImageCollectionView.reloadData()
    }
}

extension MenuReviewListContent: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
}
