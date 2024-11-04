//
//  MenuReviewHashTag.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListHashTag: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuReviewListHastTag"
    private let hashTags = ["우삽겹떡볶이*핫도그", "오뎅국"]
//    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    
    // MARK: - UI Components
    
    private lazy var reviewHashTagCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(MenuReviewHashTagCell.self, forCellWithReuseIdentifier: MenuReviewHashTagCell.identifier)
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
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
        contentView.addSubview(reviewHashTagCollectionView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewHashTagCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Create Layout
        
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // Item Size
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(25))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

            // Group Size
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewHashTagCell.identifier, for: indexPath) as! MenuReviewHashTagCell
        let isHighlighted = (indexPath.row == 0)
        cell.configure(with: hashTags[indexPath.row], isHighlighted: isHighlighted)
        return cell
    }
}
