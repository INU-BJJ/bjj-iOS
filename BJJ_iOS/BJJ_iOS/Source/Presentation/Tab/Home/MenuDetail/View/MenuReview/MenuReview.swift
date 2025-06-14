//
//  MenuReview.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReview: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var menuReviewData: HomeMenuModel?
    private var menuImages: [String] = []
    var onTapReviewPhotoGallery: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var menuReviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MenuReviewCell.self, forCellWithReuseIdentifier: MenuReviewCell.reuseIdentifier)
        $0.register(MenuReviewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MenuReviewHeaderView.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
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
         menuReviewCollectionView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuReviewCollectionView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuReview(menuReviewData: HomeMenuModel, reviewImages: [String]) {
        self.menuReviewData = menuReviewData
        self.menuImages = reviewImages
        menuReviewCollectionView.reloadData()
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: .zero, bottom: .zero, trailing: .zero)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(21))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionView DataSource

extension MenuReview: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewCell.reuseIdentifier, for: indexPath) as! MenuReviewCell
        
        if indexPath.row < menuImages.count {
            cell.configureReviewCell(reviewImage: menuImages[indexPath.row])
        } else if indexPath.row == 3 {
            cell.configureAddButton()
        } else {
            cell.configureDefaultCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuReviewHeaderView.reuseIdentifier, for: indexPath) as! MenuReviewHeaderView
            headerView.configureHeaderView(reviewCount: menuReviewData?.reviewCount ?? 0, reviewRating: menuReviewData?.menuRating ?? 0.0)
            
            return headerView
        }
        fatalError("Unexpected element kind")
    }
}

// MARK: - UICollectionView Delegate

extension MenuReview: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            onTapReviewPhotoGallery?()
        }
    }
}
