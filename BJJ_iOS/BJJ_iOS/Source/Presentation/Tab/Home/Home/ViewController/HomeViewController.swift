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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
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
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: - Action
        
        // MARK: - State
        
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
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
    
    private func setConstraints() {
        homeTopView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(182)
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
