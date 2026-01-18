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
import RxSwift
import RxCocoa

final class StoreViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let storeViewModel = StoreViewModel()
    
    // MARK: - Properties
    
    private var allItems: OrderedDictionary<ItemRarity, [StoreSection]> = [:]
    
    // MARK: - UI Components
    
    private let storeBackgroundImage = UIImageView().then {
        $0.setImage(.storeBackground)
    }
    
    private let gachaBubbleImage = UIImageView().then {
        $0.setImage(.gachaBubble)
    }
    
    private lazy var gachaMachine = UIImageView().then {
        $0.image = UIImage(named: "GachaMachine")
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGachaMachine)))
    }
    
    private let characterTabButton = UIButton().then {
        $0.setButton(title: "캐릭터", font: .pretendard_bold, size: 14, color: .customColor(.mainColor))
        $0.backgroundColor = .white
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.setCornerRadius(radius: 8)
    }
    
    private let backgroundTabButton = UIButton().then {
        $0.setButton(title: "배경", font: .pretendard_bold, size: 14, color: .white)
        $0.backgroundColor = .customColor(.mainColor)
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.setCornerRadius(radius: 8)
    }
    
    // TODO: 아이템 섹션을 rxDataSources로 나누기 + 캐릭터/배경 탭
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
        super.init(nibName: nil, bundle: nil)
        setStoreNaviBar(point: point)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshItemsValidity),
            name: .didDismissFromGachaResultVC,
            object: nil
        )
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            storeBackgroundImage,
            gachaBubbleImage,
            gachaMachine,
            characterTabButton,
            backgroundTabButton,
            testAllItemCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        storeBackgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gachaBubbleImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(109.25)
            $0.centerX.equalToSuperview()
        }
        
        gachaMachine.snp.makeConstraints {
            $0.top.equalTo(gachaBubbleImage).offset(26.75)
            $0.centerX.equalToSuperview()
        }
        
        characterTabButton.snp.makeConstraints {
            $0.top.equalTo(gachaMachine.snp.bottom).offset(35)
            $0.trailing.equalTo(backgroundTabButton.snp.leading).offset(-6)
            $0.width.equalTo(59)
            $0.height.equalTo(23.5)
        }
        
        backgroundTabButton.snp.makeConstraints {
            $0.trailing.equalTo(testAllItemCollectionView).offset(-18)
            $0.top.equalTo(characterTabButton)
            $0.size.equalTo(characterTabButton)
        }
        
        testAllItemCollectionView.snp.makeConstraints {
            $0.top.equalTo(characterTabButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = StoreViewModel.Input(
            viewDidLoad: Observable.just(()),
            characterTabTapped: characterTabButton.rx.tap.asObservable(),
            backgroundTabTapped: backgroundTabButton.rx.tap.asObservable()
        )
        let output = storeViewModel.transform(input: input)
        
        // 아이템 데이터
        output.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                self?.allItems = OrderedDictionary(
                    uniqueKeysWithValues: [ItemRarity.common, .normal, .rare]
                        .compactMap { rarity in
                            guard let itemArray = items[rarity], !itemArray.isEmpty else { return nil }
                            return (rarity, itemArray)
                        }
                )
                self?.testAllItemCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // 탭(캐릭터, 배경) 업데이트
        output.selectedTab
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] itemType in
                self?.updateTabButtonState(selectedTab: itemType)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    
    private func updateTabButtonState(selectedTab: ItemType) {
        switch selectedTab {
        case .character:
            characterTabButton.setTitleColor(.customColor(.mainColor), for: .normal)
            characterTabButton.backgroundColor = .white
            backgroundTabButton.setTitleColor(.white, for: .normal)
            backgroundTabButton.backgroundColor = .customColor(.mainColor)
        case .background:
            characterTabButton.setTitleColor(.white, for: .normal)
            characterTabButton.backgroundColor = .customColor(.mainColor)
            backgroundTabButton.setTitleColor(.customColor(.mainColor), for: .normal)
            backgroundTabButton.backgroundColor = .white
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
        // TODO: 더미 데이터 사용 중이므로 주석 처리
        // TODO: 캐릭터인지 배경인지 정하기
//        if let (itemRarity, itemID) = notification.object as? (String, Int) {
//            fetchAllItems(itemType: "CHARACTER", reloadItem: (itemRarity: itemRarity, itemID: itemID))
//        }
//        else {
//            print("[StoreVC] NotificationCenter Error: itemID를 받지 못했거나 형식이 맞지 않음")
//        }
    }

    // MARK: - Fetch API Functions (현재 더미 데이터 사용 중이므로 주석 처리)

//    private func fetchAllItems(itemType: String, reloadItem: (itemRarity: String, itemID: Int)? = nil) {
//        StoreAPI.fetchAllItems(itemType: itemType) { result in
//            switch result {
//            case .success(let allItems):
//                let items = allItems.map {
//                    StoreSection(
//                        itemID: $0.itemID,
//                        itemName: $0.itemName,
//                        itemType: ItemType(rawValue: $0.itemType) ?? .character,
//                        itemRarity: ItemRarity(rawValue: $0.itemRarity) ?? .common,
//                        itemImage: $0.itemImage,
//                        validPeriod: $0.validPeriod?.calculateItemValidPeriod(),
//                        isWearing: $0.isWearing,
//                        isOwned: $0.isOwned
//                    )
//                }
//
//                for itemRarity in [ItemRarity.common, .normal, .rare] {
//                    self.allItems[itemRarity] = items.filter { $0.itemRarity == itemRarity }
//                }
//
//                // TODO: 아이템이 배열에서 ordered dictionary로 바뀜. 새로고침하는 아이템 인덱스 수정 필요
//                DispatchQueue.main.async {
//                    UIView.performWithoutAnimation {
//                        if let reloadItem = reloadItem,
//                           let itemRarityEnum = ItemRarity(rawValue: reloadItem.itemRarity),
//                           let sectionIndex = self.allItems.keys.firstIndex(of: itemRarityEnum),
//                           let itemIndex = self.allItems[itemRarityEnum]?.firstIndex(where: { $0.itemID == reloadItem.itemID }) {
//                            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
//
//                            self.testAllItemCollectionView.reloadItems(at: [indexPath])
//                        } else {
//                            self.testAllItemCollectionView.reloadData()
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print("[StoreVC] Error: \(error.localizedDescription)")
//            }
//        }
//    }

    // MARK: - Patch API Functions (현재 더미 데이터 사용 중이므로 주석 처리)

//    private func patchItem(itemType: String, itemID: Int) {
//        // TODO: 캐릭터인지 배경인지 구분해서 PATCH 요청 보내기
//        // TODO: itemType, itemID가 없을 경우 빈 문자열과 0 보내지 말고 다른 방법 고민하기
//        GachaResultAPI.patchItem(itemType: itemType, itemID: itemID) { result in
//            switch result {
//            case .success:
//                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
//                DispatchQueue.main.async {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//
//            case .failure(let error):
//                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
//                DispatchQueue.main.async {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//                print("[GachaResultVC] Error: \(error.localizedDescription)")
//            }
//        }
//    }
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
            // TODO: 더미 데이터 사용 중이므로 주석 처리
            // patchItem(itemType: item.itemType.rawValue, itemID: item.itemID)
            print("[StoreVC] 선택한 아이템: \(item.itemName), 타입: \(item.itemType.title), 희귀도: \(item.itemRarity.title)")
        }
    }
    
    // MARK: - UICollectionView Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemSectionHeaderView.reuseIdentifier, for: indexPath) as! ItemSectionHeaderView
        let key = allItems.keys[indexPath.section]
        let itemRarity = key.title
        
        header.setUI(itemRarity: itemRarity)
        
        return header
    }
}

extension Notification.Name {
    static let didDismissFromGachaResultVC = Notification.Name("didDismissFromGachaResultVC")
}
