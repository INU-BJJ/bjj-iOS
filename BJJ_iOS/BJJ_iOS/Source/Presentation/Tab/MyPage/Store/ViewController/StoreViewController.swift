//
//  StoreViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/12/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class StoreViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let storeViewModel = StoreViewModel()
    
    // MARK: - Subjects
    
    private var viewWillAppearTrigger = PublishRelay<Void>()
    
    // MARK: - DataSource
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<StoreSectionModel>(
        configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ItemTypeCell.reuseIdentifier,
                for: indexPath
            ) as? ItemTypeCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: item)
            return cell
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ItemSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! ItemSectionHeaderView
            let section = dataSource[indexPath.section]
            header.configureHeaderView(itemRarity: section.header.title)
            return header
        }
    )
    
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
    
    private lazy var allItemCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout()
    ).then {
        $0.register(ItemSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ItemSectionHeaderView.reuseIdentifier)
        $0.register(ItemTypeCell.self, forCellWithReuseIdentifier: ItemTypeCell.reuseIdentifier)
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
    
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
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
            itemSelected: allItemCollectionView.rx.modelSelected(StoreSection.self)
        )
        let output = storeViewModel.transform(input: input)
        
        // 아이템 유효기간 갱신 Notification 구독
        NotificationCenter.default.rx
            .notification(.itemValidPeriodRefresh)
            .bind(with: self) { owner, _ in
                owner.viewWillAppearTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 아이템 데이터 바인딩
        output.items
            .observe(on: MainScheduler.instance)
            .bind(to: allItemCollectionView.rx.items(dataSource: dataSource))
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
            .withLatestFrom(output.selectedTab)
            .bind(with: self) { owner, itemType in
                // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
                owner.presentGachaViewController(itemType: itemType)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Create Flow Layout
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()

        // 아이템 사이즈 계산
        let screenWidth = UIScreen.main.bounds.width
        let collectionViewWidth = screenWidth - 40 // 양옆 20씩 inset
        let itemWidth = (collectionViewWidth - (16*2) - (4*3)) / 4
        let itemHeight: CGFloat = 92

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 50, right: 16)
        layout.headerReferenceSize = CGSize(width: collectionViewWidth, height: 60)
        
        return layout
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
}
