//
//  MenuInfo.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuInfo: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties

    private var menuComposition: [String] = []
    
    // MARK: - UI Components
    
    private let headerLabel = UILabel().then {
        $0.setLabelUI("메뉴 구성", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private lazy var menuInfoCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MenuInfoCell.self, forCellWithReuseIdentifier: MenuInfoCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.dataSource = self
        $0.backgroundColor = .customColor(.subColor)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
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
            headerLabel,
            menuInfoCollectionView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        menuInfoCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuInfo(with restMenu: [String]) {
        self.menuComposition = restMenu
        menuInfoCollectionView.reloadData()
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(17))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MenuInfo: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuComposition.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuInfoCell.reuseIdentifier, for: indexPath) as! MenuInfoCell
        let compositionItem = menuComposition[indexPath.row]
        cell.configureMenuInfoCell(with: compositionItem)
        
        return cell
    }
}
