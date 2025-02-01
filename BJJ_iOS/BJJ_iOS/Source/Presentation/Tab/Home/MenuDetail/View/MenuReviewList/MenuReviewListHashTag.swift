//
//  MenuReviewHashTag.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListHashTag: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var hashTags: [String] = []
    
    // MARK: - UI Components
    
    private lazy var reviewHashTagCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(MenuReviewHashTagCell.self, forCellWithReuseIdentifier: MenuReviewHashTagCell.reuseIdentifier)
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
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
            reviewHashTagCollectionView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewHashTagCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind Data
    
    func bindHashTagData(with hashTags: [String]) {
        self.hashTags = hashTags
    }
    
    // MARK: - Create Layout
        
    private func createLayout() -> UICollectionViewCompositionalLayout {
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

// MARK: - UICollectionViewDataSource

extension MenuReviewListHashTag: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewHashTagCell.reuseIdentifier, for: indexPath) as! MenuReviewHashTagCell
        let isHighlighted = (indexPath.row == 0)
        cell.configureHashTag(with: hashTags[indexPath.row], isHighlighted: isHighlighted)
        return cell
    }
}
