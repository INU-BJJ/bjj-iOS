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
//    private var reviewData: [asdfas] = []
    
    // MARK: - UI Components
    
    private lazy var reviewCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(MenuReviewListInfo.self, forCellWithReuseIdentifier: MenuReviewListInfo.identifier)
//        $0.register(ReviewContentCell.self, forCellWithReuseIdentifier: ReviewContentCell.identifier)
//        $0.register(ReviewHashTagCell.self, forCellWithReuseIdentifier: ReviewHashTagCell.identifier)
            
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
//        $0.backgroundColor = .clear
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
    
    func configureMenuReviewList(with items: [MenuItem]) {
//        self.menuItems = items
        reviewCollectionView.reloadData()
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createMenuReviewListInfoSection()
//            case 1:
//                return self.createReviewContentSection()
//            case 2:
//                return self.createReviewHashTagSection()
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
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    
}

extension MenuReviewList: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Info Section에 1개의 셀
//        case 1:
//            return 1 // Content Section에 1개의 셀
//        case 2:
//            return 2 // HashTag Section에 2개의 셀
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListInfo.identifier, for: indexPath) as! MenuReviewListInfo
            // 데이터 설정
            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewContentCell.identifier, for: indexPath) as! ReviewContentCell
//            // 데이터 설정
//            return cell
//        case 2:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewHashTagCell.identifier, for: indexPath) as! ReviewHashTagCell
//            // 데이터 설정
//            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}
