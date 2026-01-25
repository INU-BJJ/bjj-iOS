//
//  HomeViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    // MARK: - ViewModel
    
    private let viewModel = HomeViewModel()
    
    // MARK: - Relay
    
    private let viewWillAppearTrigger = PublishRelay<Void>()
    private let viewWillDisappearTrigger = PublishRelay<Void>()
    private let userDidScrollBannerTrigger = PublishRelay<Int>()
    
    // MARK: - Properties
    
    private var previousCafeteriaIndex: Int = 0
    private var presentCafeteriaIndex: Int = 0
    private var currentMenus: [HomeMenuModel] = []
    private var cafeteriaInfo: HomeCafeteriaInfoSection?
    
    // MARK: - UI Components
    
    private let homeTopView = HomeTopView()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(HomeCafeteriaCell.self, forCellWithReuseIdentifier: HomeCafeteriaCell.reuseIdentifier)
        $0.register(HomeMenuCell.self, forCellWithReuseIdentifier: HomeMenuCell.reuseIdentifier)
        $0.backgroundColor = .customColor(.backgroundGray)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
    }
    
    private let separatingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let cafeteriaInfoView = HomeCafeteriaInfoView()
    
    private let noticeView = NoticeView(type: .home).then {
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 홈 탭으로 돌아올 때마다 무조건 학생식당 메뉴로 돌아옴. 이전에 선택한 식당으로 돌아가도록 설계 변경?
        reloadCafeteriaSection()
        fetchAllMenuData(cafeteriaName: "학생식당")
        fetchCafeteriaInfo(cafeteriaName: "학생식당") { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.cafeteriaInfoView.configureCafeteriaInfoView(
                    with: self.cafeteriaInfo ?? HomeCafeteriaInfoSection(
                        cafeteriaName: "",
                        cafeteriaLocation: "",
                        serviceTime: CafeteriaServiceTime(
                            serviceHourTitle: "",
                            weekDaysServiceTime: [],
                            weekendsServiceTime: []
                        ),
                        cafeteriaMapImage: ""
                    )
                )
            }
        }
        viewWillAppearTrigger.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearTrigger.accept(())
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = HomeViewModel.Input(
            viewWillAppear: viewWillAppearTrigger,
            viewWillDisappear: viewWillDisappearTrigger,
            userDidScrollBanner: userDidScrollBannerTrigger
        )
        let output = viewModel.transform(input: input)
        
        // 배너 리스트
        output.bannerList
            .drive(homeTopView.bannerCollectionView.rx.items(
                cellIdentifier: BannerCollectionViewCell.reuseIdentifier,
                cellType: BannerCollectionViewCell.self
            )) { index, banner, cell in
                cell.configureCell(with: banner)
                cell.bannerTapGesture.rx.event
                    .bind(with: self) { owner, _ in
                        owner.pushBannerVC(bannerURI: banner.uri)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 배너 리스트가 로드된 후 초기 위치를 인덱스 1로 설정 (진짜 첫 번째 배너)
        output.bannerList
            .drive(with: self) { owner, banners in
                guard banners.count > 1 else { return }

                // 레이아웃이 완료된 후 설정해야 정확한 contentOffset 계산 가능
                DispatchQueue.main.async {
                    let collectionView = owner.homeTopView.bannerCollectionView

                    // 레이아웃 강제 업데이트
                    collectionView.layoutIfNeeded()

                    // frame.width가 0이 아닐 때만 설정
                    guard collectionView.frame.width > 0 else { return }

                    // X축만 인덱스 1로 이동, Y축은 현재 값 유지
                    let currentY = collectionView.contentOffset.y
                    let initialOffset = CGPoint(x: collectionView.frame.width, y: currentY)
                    collectionView.setContentOffset(initialOffset, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        // 자동 스크롤
        output.scrollToIndex
            .drive(with: self) { owner, index in
                let collectionView = owner.homeTopView.bannerCollectionView
                let itemCount = collectionView.numberOfItems(inSection: 0)

                if index < itemCount {
                    // X축만 변경, Y축은 현재 값 유지
                    let currentY = collectionView.contentOffset.y
                    let targetX = CGFloat(index) * collectionView.frame.width
                    let targetOffset = CGPoint(x: targetX, y: currentY)

                    collectionView.setContentOffset(targetOffset, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 사용자 스크롤 감지 및 무한 스크롤 처리
        homeTopView.bannerCollectionView.rx.didEndDecelerating
            .bind(with: self) { owner, _ in
                owner.handleInfiniteScroll()
            }
            .disposed(by: disposeBag)

        // 자동 스크롤 종료 시 무한 스크롤 처리
        homeTopView.bannerCollectionView.rx.didEndScrollingAnimation
            .bind(with: self) { owner, _ in
                owner.handleInfiniteScroll()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Handle Infinite Scroll
    
    /// 무한 스크롤 처리: 가짜 아이템에 도달하면 진짜 아이템으로 순간이동
    private func handleInfiniteScroll() {
        let collectionView = homeTopView.bannerCollectionView
        let itemCount = collectionView.numberOfItems(inSection: 0)

        guard itemCount > 2 else { return } // 중복 아이템이 없으면 무한 스크롤 불필요

        // 현재 인덱스 계산
        let currentIndex = Int(round(collectionView.contentOffset.x / collectionView.frame.width))

        // 현재 Y값 저장 (순간이동 시에도 유지)
        let currentY = collectionView.contentOffset.y
        
        // 가짜 아이템 위치 판단 및 순간이동
        if currentIndex == 0 {
            // 가짜 마지막 아이템 (인덱스 0) → 진짜 마지막 아이템 (인덱스 itemCount - 2)
            let realLastIndex = itemCount - 2
            let targetOffset = CGPoint(x: CGFloat(realLastIndex) * collectionView.frame.width, y: currentY)
            collectionView.setContentOffset(targetOffset, animated: false)
            userDidScrollBannerTrigger.accept(realLastIndex)
        } else if currentIndex == itemCount - 1 {
            // 가짜 첫 아이템 (인덱스 itemCount - 1) → 진짜 첫 아이템 (인덱스 1)
            let realFirstIndex = 1
            let targetOffset = CGPoint(x: CGFloat(realFirstIndex) * collectionView.frame.width, y: currentY)
            collectionView.setContentOffset(targetOffset, animated: false)
            userDidScrollBannerTrigger.accept(realFirstIndex)
        } else {
            // 진짜 아이템 위치에서는 타이머 재시작만 수행
            userDidScrollBannerTrigger.accept(currentIndex)
        }
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            homeTopView,
            scrollView
        ].forEach(view.addSubview)
        
        [
            collectionView,
            separatingView,
            cafeteriaInfoView,
            noticeView
        ].forEach(scrollView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        homeTopView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(215)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(homeTopView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(85)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(423)
        }
        
        separatingView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(7)
        }
        
        cafeteriaInfoView.snp.makeConstraints {
            $0.top.equalTo(separatingView.snp.bottom)
            $0.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalToSuperview().inset(450)
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(-205)
            $0.centerX.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    // MARK: - Create Layout
    
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(124), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let itemWidth: CGFloat = 124
        let itemSpacing: CGFloat = 9
        let itemCount = HomeCafeteriaModel.cafeteria.count
        let cafeteriaSectionWidth = (itemWidth * CGFloat(itemCount)) + (itemSpacing * CGFloat(itemCount - 1))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(cafeteriaSectionWidth), heightDimension: .absolute(33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(9)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0)
        
        return section
    }
    
    private func createMenuSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 21)
        
        return section
    }
    
    // MARK: - Fetch API
    
    private func fetchAllMenuData(cafeteriaName: String) {
        HomeAPI.fetchHomeAllMenuInfo(cafeteriaName: cafeteriaName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let menuInfos):
                DispatchQueue.main.async {
                    // 서버 데이터를 currentMenus에 저장
                    self.currentMenus = menuInfos.map { menu in
                        HomeMenuModel(
                            menuName: menu.mainMenuName,
                            menuImage: menu.reviewImageName ?? "DefaultMenuImage",
                            menuPrice: menu.price,
                            menuRating: menu.reviewRatingAverage,
                            cafeteriaName: menu.cafeteriaName,
                            cafeteriaCorner: menu.cafeteriaCorner,
                            isLikedMenu: menu.likedMenu,
                            restMenu: menu.restMenu?.components(separatedBy: " ") ?? [],
                            reviewCount: menu.reviewCount,
                            menuPairID: menu.menuPairID,
                            mainMenuID: menu.mainMenuID,
                            subMenuID: menu.subMenuID
                        )
                    }
                    // 메뉴 섹션 애니메이션 효과 없이 새로고침 
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadSections(IndexSet(integer: 1))
                    }
                    
                    self.noticeView.setNoticeViewVisibility(self.currentMenus.isEmpty)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // 에러 처리 (필요 시 UI에 에러 메시지 표시 가능)
                    print("Error fetching menu data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchCafeteriaInfo(cafeteriaName: String, completion: @escaping () -> Void) {
        HomeAPI.fetchCafeteriaInfo(cafeteriaName: cafeteriaName) { result in
            switch result {
            case .success(let response):
                self.cafeteriaInfo = HomeCafeteriaInfoSection(
                    cafeteriaName: response.cafeteriaName,
                    cafeteriaLocation: response.cafeteriaLocation,
                    serviceTime: CafeteriaServiceTime(
                                    serviceHourTitle: response.serviceTime.serviceHourTitle,
                                    weekDaysServiceTime: response.serviceTime.weekDaysServiceTime,
                                    weekendsServiceTime: response.serviceTime.weekendsServiceTime
                                ),
                    cafeteriaMapImage: response.cafeteriaMapImage
                )
                completion()
                
            case .failure(let error):
                print("[Home fetchCafeteriaInfo Error]: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Reload CafeteriaSection
    
    private func reloadCafeteriaSection() {
        presentCafeteriaIndex = 0
        collectionView.reloadSections(IndexSet(integer: 0))
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
        let selectedSection = indexPath.section
        if selectedSection == 0 {
            // 식당 섹션
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCafeteriaCell.reuseIdentifier, for: indexPath) as! HomeCafeteriaCell
            let cafeteria = HomeCafeteriaModel.cafeteria[indexPath.item]
            let isSelected = indexPath.item == presentCafeteriaIndex
            
            cell.configureCell(with: cafeteria.text, isSelected: isSelected)
            return cell
        } else {
            // 메뉴 섹션
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCell.reuseIdentifier, for: indexPath) as! HomeMenuCell
            let menu = currentMenus[indexPath.item]
            cell.configureCell(
                menuName: menu.menuName,
                menuPrice: menu.menuPrice,
                imageName: menu.menuImage ?? "DefaultMenuImage",
                cafeteriaName: menu.cafeteriaName,
                cafeteriaCorner: menu.cafeteriaCorner,
                menuRating: menu.menuRating,
                isLikedMenu: menu.isLikedMenu
            )
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 색 변환 애니메이션 넣을지 말지
        
        let selectedSection = indexPath.section
        var cafeteriaName: String
        
        if selectedSection == 0 { // 식당 섹션에서 선택 시
            previousCafeteriaIndex = presentCafeteriaIndex
            presentCafeteriaIndex = indexPath.item
            
            // 선택된 식당에 따른 메뉴 설정
            switch presentCafeteriaIndex {
            case 0:
                cafeteriaName = "학생식당"
                
            case 1:
                cafeteriaName = "2호관식당"
                
            case 2:
                cafeteriaName = "제1기숙사식당"
                
            case 3:
                cafeteriaName = "27호관식당"
                
            case 4:
                cafeteriaName = "사범대식당"
                
            default:
                currentMenus = []
                cafeteriaName = ""
            }
            
            fetchAllMenuData(cafeteriaName: cafeteriaName)
            fetchCafeteriaInfo(cafeteriaName: cafeteriaName) { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.cafeteriaInfoView.configureCafeteriaInfoView(
                        with: self.cafeteriaInfo ?? HomeCafeteriaInfoSection(
                            cafeteriaName: "",
                            cafeteriaLocation: "",
                            serviceTime: CafeteriaServiceTime(
                                serviceHourTitle: "",
                                weekDaysServiceTime: [],
                                weekendsServiceTime: []
                            ),
                            cafeteriaMapImage: ""
                        )
                    )
                }
            }
            
            // 식당 섹션의 이전에 선택했던 아이템, 현재 선택한 아이템만 업데이트
            if let previousCell = collectionView.cellForItem(at: IndexPath(item: previousCafeteriaIndex, section: 0)) as? HomeCafeteriaCell {
                let previousCafeteria = HomeCafeteriaModel.cafeteria[previousCafeteriaIndex]
                
                previousCell.configureCell(with: previousCafeteria.text, isSelected: false)
            }

            if let currentCell = collectionView.cellForItem(at: IndexPath(item: presentCafeteriaIndex, section: 0)) as? HomeCafeteriaCell {
                let currentCafeteria = HomeCafeteriaModel.cafeteria[presentCafeteriaIndex]
                
                currentCell.configureCell(with: currentCafeteria.text, isSelected: true)
            }
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            cafeteriaInfoView.configureCafeteriaInfoView(
                with: cafeteriaInfo ?? HomeCafeteriaInfoSection(
                    cafeteriaName: "",
                    cafeteriaLocation: "",
                    serviceTime: CafeteriaServiceTime(
                        serviceHourTitle: "",
                        weekDaysServiceTime: [],
                        weekendsServiceTime: []
                    ),
                    cafeteriaMapImage: ""
                )
            )
            
        } else {    // 메뉴 섹션에서 선택 시
            let selectedMenu = currentMenus[indexPath.item]
            
            let menuDetailVC = MenuDetailViewController()
            menuDetailVC.bindData(menu: selectedMenu)
            menuDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(menuDetailVC, animated: true)
        }
    }
}
