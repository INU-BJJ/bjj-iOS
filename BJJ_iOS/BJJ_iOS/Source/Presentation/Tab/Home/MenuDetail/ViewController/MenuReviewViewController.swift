//
//  MenuDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let menuDefaultImageView = UIImageView().then {
        $0.image = UIImage(named: "MenuImage2")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var menuReviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MenuHeader.self, forCellWithReuseIdentifier: MenuHeader.identifier)
        $0.register(MenuInfo.self, forCellWithReuseIdentifier: MenuInfo.identifier)
        $0.register(MenuReview.self, forCellWithReuseIdentifier: MenuReview.identifier)
        $0.register(MenuReviewSorting.self, forCellWithReuseIdentifier: MenuReviewSorting.identifier)
        $0.register(MenuReviewList.self, forCellWithReuseIdentifier: MenuReviewList.identifier)
        $0.register(SeparatingLineView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeparatingLineView.identifier)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: - Action
        
        // MARK: - State
        
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            menuDefaultImageView,
            menuReviewCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuDefaultImageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(272)
        }
        
        menuReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(231)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createMenuHeaderSection()    // 메뉴 정보 섹션
            case 1:
                return self.createMenuInfoSection() // 메뉴 구성 섹션
            case 2:
                return self.createReviewSection() // 리뷰 헤더 섹션 (가로 스크롤 사진 포함)
            case 3:
                return self.createReviewSortingSection() // 리뷰 정렬 섹션
            case 4:
                return self.createReviewListSection()   // 리뷰 리스트 섹션
            default:
                return nil
            }
        }
    }
    
    // MARK: - Create Section
    
    private func createMenuHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 41, leading: 24, bottom: 23, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createMenuInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(176))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(176))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 24, bottom: 16, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 24, bottom: 17, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewSortingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(403))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(403))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 24, bottom: 17, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
}

extension MenuReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1      // 메뉴 정보는 하나의 셀만 필요
        case 1:
            return 1      // 메뉴 구성도 하나의 셀로 표시
        case 2:
            return 1      // 리뷰 헤더도 하나의 셀로 구성
        case 3:
            return 1
        case 4:
            return 1  // 리뷰 리스트는 현재 필터링된 리뷰 개수에 따라 동적으로 결정
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuHeader.identifier, for: indexPath) as! MenuHeader
            cell.configureMenuHeader(menuName: "양상추샐러드/복숭아아이스티", menuPrice: "5,500원")
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuInfo.identifier, for: indexPath) as! MenuInfo
            cell.configureMenuInfo(with: menuData)
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReview.identifier, for: indexPath) as! MenuReview
            cell.configureMenuReview(with: menuData)
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewSorting.identifier, for: indexPath) as! MenuReviewSorting
            
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewList.identifier, for: indexPath) as! MenuReviewList
//            let review = currentReviews[indexPath.item]
            cell.configureMenuReviewList(with: menuData)
            
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SeparatingLineView.identifier,
                for: indexPath
            ) as! SeparatingLineView
            
            // 마지막 섹션에는 구분선을 표시하지 않을 경우
            footer.isHidden = indexPath.section == 4
            
            return footer
        }
        return UICollectionReusableView()
    }
}
