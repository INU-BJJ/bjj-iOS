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
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            reviewStackView
        ].forEach(contentView.addSubview)
        
        [
            menuReviewInfoView,
            reviewCommentLabel,
            reviewImageCollectionView,
//            reviewHashTagCollectionView
        ].forEach(reviewStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(390)
        }
        
        menuReviewInfoView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    // MARK: - Configure Cell
    
    func configure(with menuReview: MenuDetailModel) {
        self.reviewImages = menuReview.reviewImage ?? []
        
        let reviewImageCount = menuReview.reviewImage?.count ?? 0
        let flowLayout = createFlowLayout(reviewImageCount: reviewImageCount)
        
        menuReviewInfoView.setUI(with: menuReview)
        reviewCommentLabel.text = menuReview.reviewComment
        reviewImageCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        if reviewImages.isEmpty {
            reviewImageCollectionView.removeFromSuperview()
        }
        
        DispatchQueue.main.async {
            self.reviewImageCollectionView.reloadData()
        }
    }
    
    // MARK: - Create FlowLayout
    
    func createFlowLayout(reviewImageCount: Int) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        
        switch reviewImageCount {
        case 1:
            layout.itemSize = CGSize(width: 301, height: 250)
        case 2:
            layout.itemSize = CGSize(width: 149.5, height: 250)
        case 3:
            layout.itemSize = CGSize(width: 140.72, height: 250)
        case 4:
            layout.itemSize = CGSize(width: 140.72, height: 250)
        default:
            layout.itemSize = CGSize(width: 301, height: 250)
        }

        // section에 대한 여백을 설정합니다. (콘텐츠뷰 여백)
//        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        
        // header, footer 크기 지정
        // 스크롤 방향에 따라서 크기가 영향을 받는다. (vertical은 height값만 갖고 계산, horizontal 일 경우 width만 영향을 받는다)
//        layout.headerReferenceSize = CGSize(width: 50, height: 100)
//        layout.footerReferenceSize = CGSize(width: 50, height: 100)
        // header, footer를 고정 시킴 (기본값 false)
//        layout.sectionHeadersPinToVisibleBounds = true
//        layout.sectionFootersPinToVisibleBounds = true
        
        return layout
    }
}

extension MenuReviewListCell: UICollectionViewDataSource {
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
