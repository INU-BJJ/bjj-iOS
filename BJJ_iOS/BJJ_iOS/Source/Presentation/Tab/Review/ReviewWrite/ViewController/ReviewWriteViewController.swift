//
//  ReviewWriteViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/7/25.
//

import UIKit
import SnapKit
import Then

final class ReviewWriteViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var reviewWriteCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(ReviewCategorySelectCell.self, forCellWithReuseIdentifier: ReviewCategorySelectCell.reuseIdentifier)
        $0.register(SeparatingLineView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeparatingLineView.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        
        // TODO: 경계선 삭제
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("리뷰 작성하기")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            reviewWriteCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewWriteCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(152)
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createCategorySelectSection()
            default:
                return nil
            }
        }
    }
    
    // MARK: - Create Section
    
    private func createCategorySelectSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(114))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        // TODO: 다른 셀과의 간격 조정
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
//        section.contentInsets = NSDirectionalEdgeInsets(top: 41, leading: 24, bottom: 23, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
}

extension ReviewWriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCategorySelectCell.reuseIdentifier, for: indexPath) as! ReviewCategorySelectCell
            
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SeparatingLineView.reuseIdentifier,
                for: indexPath
            ) as! SeparatingLineView
            
            // Footer Style 지정
            footer.configureLineView(.menuDetail)
            
            return footer
        }
        return UICollectionReusableView()
    }
}
