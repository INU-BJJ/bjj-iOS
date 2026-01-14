//
//  StoreViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/12/25.
//

import UIKit
import SnapKit
import Then
import OrderedCollections

final class StoreViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var point: Int
    private var allItems: OrderedDictionary<String, [StoreSection]> = [:]
    
    // MARK: - UI Components
    
    private let testPointLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private lazy var testGachaMachine = UIImageView().then {
        $0.image = UIImage(named: "GachaMachine")
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGachaMachine)))
    }
    
    private lazy var testAllItemCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    ).then {
        $0.register(ItemSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ItemSectionHeaderView.reuseIdentifier)
        $0.register(ItemTypeCell.self, forCellWithReuseIdentifier: ItemTypeCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - LifeCycle
    
    init(point: Int) {
        self.point = point
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllItems(itemType: "CHARACTER")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setStoreNaviBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshItemsValidity),
            name: .didDismissFromGachaResultVC,
            object: nil
        )
        
        DispatchQueue.main.async {
            // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
            self.testPointLabel.text = "\(self.point) P"
        }
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            testPointLabel,
            testGachaMachine,
            testAllItemCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        testPointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        testGachaMachine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        testAllItemCollectionView.snp.makeConstraints {
            $0.top.equalTo(testGachaMachine.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Create Layout
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            // 헤더 설정
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(30)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            
            // 아이템 설정
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .absolute(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 그룹 설정
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 4
            )
            group.interItemSpacing = .fixed(10)
            
            // 섹션 설정
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 80, trailing: .zero)
            section.orthogonalScrollingBehavior = .none
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapGachaMachine() {
        DispatchQueue.main.async {
            // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
            self.presentGachaViewController()
        }
    }
    
    @objc private func refreshItemsValidity(_ notification: Notification) {
        // TODO: 캐릭터인지 배경인지 정하기
        if let (itemRarity, itemID) = notification.object as? (String, Int) {
            fetchAllItems(itemType: "CHARACTER", reloadItem: (itemRarity: itemRarity, itemID: itemID))
        }
        else {
            print("[StoreVC] NotificationCenter Error: itemID를 받지 못했거나 형식이 맞지 않음")
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchAllItems(itemType: String, reloadItem: (itemRarity: String, itemID: Int)? = nil) {
        StoreAPI.fetchAllItems(itemType: itemType) { result in
            switch result {
            case .success(let allItems):
                let items = allItems.map {
                    StoreSection(
                        itemID: $0.itemID,
                        itemName: $0.itemName,
                        itemType: $0.itemType,
                        itemRarity: $0.itemRarity,
                        itemImage: $0.itemImage,
                        validPeriod: $0.validPeriod?.calculateItemValidPeriod(),
                        isWearing: $0.isWearing,
                        isOwned: $0.isOwned
                    )
                }
                
                for itemRarity in ["COMMON", "NORMAL", "RARE"] {
                    self.allItems[itemRarity] = items.filter { $0.itemRarity == itemRarity }
                }
                
                // TODO: 아이템이 배열에서 ordered dictionary로 바뀜. 새로고침하는 아이템 인덱스 수정 필요
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        if let reloadItem = reloadItem,
                           let sectionIndex = self.allItems.keys.firstIndex(of: reloadItem.itemRarity),
                           let itemIndex = self.allItems[reloadItem.itemRarity]?.firstIndex(where: { $0.itemID == reloadItem.itemID }) {
                            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                            
                            self.testAllItemCollectionView.reloadItems(at: [indexPath])
                        } else {
                            self.testAllItemCollectionView.reloadData()
                        }
                    }
                }
                
            case .failure(let error):
                print("[StoreVC] Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Patch API Functions
    
    private func patchItem(itemType: String, itemID: Int) {
        // TODO: 캐릭터인지 배경인지 구분해서 PATCH 요청 보내기
        // TODO: itemType, itemID가 없을 경우 빈 문자열과 0 보내지 말고 다른 방법 고민하기
        GachaResultAPI.patchItem(itemType: itemType, itemID: itemID) { result in
            switch result {
            case .success:
                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            case .failure(let error):
                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                print("[GachaResultVC] Error: \(error.localizedDescription)")
            }
        }
    }
}

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView Section
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = allItems.keys[section]
        
        return allItems[key]?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemTypeCell.reuseIdentifier, for: indexPath) as? ItemTypeCell else {
            return UICollectionViewCell()
        }
        
        let key = allItems.keys[indexPath.section]
        
        if let item = allItems[key]?[indexPath.item] {
            cell.setUI(itemInfo: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = allItems.keys[indexPath.section]
        
        if let item = allItems[key]?[indexPath.item] {
            patchItem(itemType: item.itemType, itemID: item.itemID)
        }
    }
    
    // MARK: - UICollectionView Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemSectionHeaderView.reuseIdentifier, for: indexPath) as! ItemSectionHeaderView
        let key = allItems.keys[indexPath.section]
        let itemRarity = ItemRarity(rawValue: key)?.koreanTitle ?? key
        
        header.setUI(itemRarity: itemRarity)
        
        return header
    }
}

extension Notification.Name {
    static let didDismissFromGachaResultVC = Notification.Name("didDismissFromGachaResultVC")
}
