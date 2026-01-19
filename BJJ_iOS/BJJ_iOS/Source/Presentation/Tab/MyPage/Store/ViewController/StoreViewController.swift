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
    
    // MARK: - Subjects
    
    private var viewWillAppearTrigger = PublishRelay<Void>()
    private var itemSelectedSubject = PublishSubject<(itemType: String, itemID: Int)>()
    
    // MARK: - UI Components
    
    private let storeBackgroundImage = UIImageView().then {
        $0.setImage(.storeBackground)
    }
    
    private let gachaBubbleImage = UIImageView().then {
        $0.setImage(.gachaBubble)
    }
    
    private let gachaMachine = UIButton().then {
        $0.setImage(UIImage(named: ImageAsset.GachaMachine.name), for: .normal)
    }
    
    private let characterTabButton = UIButton().then {
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.setCornerRadius(radius: 8)
    }
    
    private let backgroundTabButton = UIButton().then {
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.setCornerRadius(radius: 8)
    }
    
    // TODO: 아이템 섹션을 rxDataSources로 나누기 + 캐릭터/배경 탭
    private lazy var allItemCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.register(ItemSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ItemSectionHeaderView.reuseIdentifier)
        $0.register(ItemTypeCell.self, forCellWithReuseIdentifier: ItemTypeCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .FFD_36_A
        $0.setBorder(color: .C_49_A_6_C, width: 1.5)
        $0.setCornerRadius(radius: 16)
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
        viewWillAppearTrigger.accept(())
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
            allItemCollectionView
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
            $0.trailing.equalTo(allItemCollectionView).offset(-18)
            $0.top.equalTo(characterTabButton)
            $0.size.equalTo(characterTabButton)
        }
        
        allItemCollectionView.snp.makeConstraints {
            $0.top.equalTo(characterTabButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(35)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = StoreViewModel.Input(
            viewWillAppear: viewWillAppearTrigger.asObservable(),
            characterTabTapped: characterTabButton.rx.tap.asObservable(),
            backgroundTabTapped: backgroundTabButton.rx.tap.asObservable(),
            itemSelected: itemSelectedSubject.asObservable()
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
                self?.allItemCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // 탭(캐릭터, 배경) 업데이트
        output.selectedTab
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, itemType in
                owner.updateTabButtonState(selectedTab: itemType)
            })
            .disposed(by: disposeBag)
        
        // 마이페이지로 이동 (아이템 선택 후 PATCH 성공 시)
        output.dismissToMyPage
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)

        // 뽑기 머신 탭
        gachaMachine.rx.tap
            .bind(with: self) { owner, _ in
                // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
                owner.presentGachaViewController()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update Tab Button UI
    
    private func updateTabButtonState(selectedTab: ItemType) {
        switch selectedTab {
        case .character:
            characterTabButton.setButton(title: "캐릭터", font: .pretendard_bold, size: 14, color: .customColor(.mainColor))
            characterTabButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 11, bottom: 1.5, trailing: 11)
            characterTabButton.backgroundColor = .white
            backgroundTabButton.setButton(title: "배경", font: .pretendard_bold, size: 14, color: .white)
            backgroundTabButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 17, bottom: 1.5, trailing: 17)
            backgroundTabButton.backgroundColor = .customColor(.mainColor)
        case .background:
            characterTabButton.setButton(title: "캐릭터", font: .pretendard_bold, size: 14, color: .white)
            characterTabButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 11, bottom: 1.5, trailing: 11)
            characterTabButton.backgroundColor = .customColor(.mainColor)
            backgroundTabButton.setButton(title: "배경", font: .pretendard_bold, size: 14, color: .customColor(.mainColor))
            backgroundTabButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 17, bottom: 1.5, trailing: 17)
            backgroundTabButton.backgroundColor = .white
        }
    }
    
    // MARK: - Objc Functions

    @objc private func refreshItemsValidity(_ notification: Notification) {
        // viewWillAppear 트리거를 호출하여 아이템 목록 새로고침
        viewWillAppearTrigger.accept(())
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
            cell.configureCell(with: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = allItems.keys[indexPath.section]
        
        if let item = allItems[key]?[indexPath.item] {
            // ViewModel에 아이템 선택 이벤트 전달
            itemSelectedSubject.onNext((itemType: item.itemType.rawValue, itemID: item.itemID))
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
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        // collectionView 너비 - 양옆 padding - 아이템 사이 간격
        let itemWidth = (collectionViewWidth - (16*2) - (4*3)) / 4
        let itemHeight: CGFloat = 92
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 50, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}

extension Notification.Name {
    static let didDismissFromGachaResultVC = Notification.Name("didDismissFromGachaResultVC")
}
