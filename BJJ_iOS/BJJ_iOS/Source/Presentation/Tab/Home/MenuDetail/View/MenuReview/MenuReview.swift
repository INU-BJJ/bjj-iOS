//
//  MenuReview.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReview: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuReview"
    private var menuImages: [String] = []
    
    // MARK: - UI Components
    
    private lazy var menuReviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MenuReviewCell.self, forCellWithReuseIdentifier: MenuReviewCell.identifier)
        $0.register(MenuReviewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MenuReviewHeaderView.identifier)
        $0.dataSource = self
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
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuReview(with items: ReviewListItem) {
        self.menuImages = items.reviewList.map { $0.menu.menuImage }
        menuReviewCollectionView.reloadData()
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(68), heightDimension: .absolute(67))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(67))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        // TODO: top, bottom inset 크기가 다름. 질문하기
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 17, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(21))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MenuReview: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewCell.identifier, for: indexPath) as! MenuReviewCell
        
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuReviewHeaderView.identifier, for: indexPath) as! MenuReviewHeaderView
            
            return headerView
        }
        fatalError("Unexpected element kind")
    }
}

