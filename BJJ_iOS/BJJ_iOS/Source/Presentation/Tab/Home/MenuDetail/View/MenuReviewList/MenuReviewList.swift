//
//  MenuReviewList.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewList: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuReviewList"
    private var menuReview: [MenuReviewInfo] = []
    
    // MARK: - UI Components
    
    private lazy var reviewCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(MenuReviewListInfo.self, forCellWithReuseIdentifier: MenuReviewListInfo.identifier)
            $0.register(MenuReviewListContent.self, forCellWithReuseIdentifier: MenuReviewListContent.identifier)
            $0.register(MenuReviewListHashTag.self, forCellWithReuseIdentifier: MenuReviewListHashTag.identifier)
            $0.register(MenuReviewSeparatingView.self, forCellWithReuseIdentifier: MenuReviewSeparatingView.identifier)
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
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
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            reviewCollectionView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuReviewList(with items: Review) {
        self.menuReview = items.menuReviewList
        reviewCollectionView.reloadData()
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createMenuReviewListInfoSection()
            case 1:
                return self.createMenuReviewListContentSection()
            case 2:
                return self.createMenuReviewListHashTagSection()
            case 3:
                return self.createMenuReviewSeparatingSection()
            default:
                return nil
            }
        }
    }
    
    private func createMenuReviewListInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(41))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(41))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 46, bottom: 0, trailing: 46)
        
        return section
    }
    
    private func createMenuReviewListContentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 46, bottom: 12, trailing: 46)
        
        return section
    }
    
    private func createMenuReviewListHashTagSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 46, bottom: 17, trailing: 46)
        
        return section
    }
    
    private func createMenuReviewSeparatingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(7))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

extension MenuReviewList: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Info Section에 1개의 셀
        case 1:
            return 1 // Content Section에 1개의 셀
        case 2:
            return 1 // HashTag Section에 2개의 셀
        case 3:
            return 1 // SeparatingView 1개의 셀
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListInfo.identifier, for: indexPath) as! MenuReviewListInfo
            cell.configureReviewListInfo(with: menuReview[indexPath.row])
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListContent.identifier, for: indexPath) as! MenuReviewListContent
            cell.configureReviewListContent(with: menuReview[indexPath.row])
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListHashTag.identifier, for: indexPath) as! MenuReviewListHashTag
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewSeparatingView.identifier, for: indexPath) as! MenuReviewSeparatingView
            
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}
