//
//  HomeViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {

    // MARK: Properties
    
    private let homeTopView = HomeTopView()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.register(HomeCafeteriaCell.self, forCellWithReuseIdentifier: HomeCafeteriaCell.identifier)
        $0.register(HomeMenuCell.self, forCellWithReuseIdentifier: HomeMenuCell.identifier)
    }
    
    private var selectedCafeteriaIndex: Int = 0
    private var currentMenus: [HomeMenuModel] = HomeMenuModel.studentCafeteriaMenu
    
    // MARK: UI Components
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
                
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: Bind
    
    func bind() {
        
        // MARK: Action
        
        // MARK: State
        
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: Set AddViews
    
    private func setAddView() {
        [
         homeTopView,
         collectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        homeTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(182)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(homeTopView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().offset(-265)
        }
    }
    
    // MARK: Other Fucntions
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createCafeteriaSection()
            case 1:
                return self.createMenuSection()
            default:
                return nil
            }
        }
    }
    
    private func createCafeteriaSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
    
    private func createMenuSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // 첫 번째는 식당 섹션, 두 번째는 메뉴 섹션
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return HomeCafeteriaModel.cafeteria.count // 식당 개수
        } else {
            return currentMenus.count // 현재 선택된 식당의 메뉴 개수
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // 식당 섹션
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCafeteriaCell.identifier, for: indexPath) as! HomeCafeteriaCell
            let cafeteria = HomeCafeteriaModel.cafeteria[indexPath.item]
            cell.configureCell(with: cafeteria.text)
            return cell
        } else {
            // 메뉴 섹션
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCell.identifier, for: indexPath) as! HomeMenuCell
            let menu = currentMenus[indexPath.item]
            cell.configureCell(with: menu.text, imageName: menu.image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                // 식당 섹션에서 선택 시
                selectedCafeteriaIndex = indexPath.item
                
                // 선택된 식당에 따른 메뉴 설정
                switch selectedCafeteriaIndex {
                case 0:
                    currentMenus = HomeMenuModel.studentCafeteriaMenu
                case 1:
                    currentMenus = HomeMenuModel.staffCafeteriaMenu
                case 2:
                    currentMenus = HomeMenuModel.dormitoryCafeteriaMenu
                default:
                    currentMenus = []
                }
                
                // 메뉴 섹션만 업데이트
                collectionView.reloadSections(IndexSet(integer: 1))
            }
        }
}

