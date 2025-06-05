//
//  MenuDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/2/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class MenuDetailViewController: UIViewController {
    
    // MARK: - Properties

    private var menuData: HomeMenuModel?
    private var reviewData: [MenuDetailModel] = []
    private var reviewImages: [String] = []
    
    // Debounce, Throttle
    private var scrollDebounceTimer: Timer?
    private var lastHeightUpdateTime: Date = .distantPast
    private let heightUpdateInterval: TimeInterval = 1
    
    private var reviewLikeDebounceTimers: [Int: Timer] = [:]
    private let reviewLikeDebounceInterval: TimeInterval = 0.5
    
    // TODO: 네비바 숨김 방식 고민하기
    private var isNavigationBarHidden = false
    
    private var currentPageNumber = 0
    private var pageSize = 5
    private var isFetching = false
    private var isLastPage = false
    private var isOnlyPhotoChecked = false
    private var sortingCriteria = "BEST_MATCH"
    
    private var presentMenuReviewListCollectionViewHeight: CGFloat = 0
    private var presentMenuReviewCollectionViewHeight: CGFloat = 0
    
    // TODO: Enum으로 관리
    private let sortingOptions = ["메뉴일치순", "좋아요순", "최신순"]
    private var isReviewSortingExpanded = false
    private var selectedSortingIndex: Int = 0
    
    // MARK: - UI Components
    
    private lazy var menuReviewScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    
    private let menuReviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = -41
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let menuDefaultImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // TODO: collectionView 통일화
//    https://velog.io/@hyesuuou/iOSSwift-Compositional-Layout에서-Dynamic-height-이용해보기
//    https://akwlak.tistory.com/24
//    https://www.google.com/search?client=safari&rls=en&q=compositional+layout+dynamic+height&ie=UTF-8&oe=UTF-8
    
    private lazy var menuReviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(MenuHeader.self, forCellWithReuseIdentifier: MenuHeader.reuseIdentifier)
        $0.register(MenuInfo.self, forCellWithReuseIdentifier: MenuInfo.reuseIdentifier)
        $0.register(MenuReview.self, forCellWithReuseIdentifier: MenuReview.reuseIdentifier)
        $0.register(MenuReviewSorting.self, forCellWithReuseIdentifier: MenuReviewSorting.reuseIdentifier)
        $0.register(SeparatingLineView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeparatingLineView.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = false
        $0.isScrollEnabled = false
    }
    
    private lazy var menuReviewListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout()
    ).then {
        $0.register(MenuReviewListCell.self, forCellWithReuseIdentifier: MenuReviewListCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
    }
    
    private lazy var shadowContainerView = UIView().then {
        let firstLayer = CALayer()
        firstLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        firstLayer.shadowOpacity = 1
        firstLayer.shadowRadius = 2.5
        firstLayer.shadowOffset = CGSize(width: 0, height: 1)

        let secondLayer = CALayer()
        secondLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        secondLayer.shadowOpacity = 1
        secondLayer.shadowRadius = 3.9
        secondLayer.shadowOffset = CGSize(width: 0, height: 2)
        
        $0.layer.insertSublayer(firstLayer, at: 0)
        $0.layer.insertSublayer(secondLayer, at: 1)
        $0.layer.setValue(firstLayer, forKey: "firstLayerShadow")
        $0.layer.setValue(secondLayer, forKey: "secondLayerShadow")
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private lazy var reviewSortingTableView = UITableView().then {
        $0.register(MenuReviewSortingCell.self, forCellReuseIdentifier: MenuReviewSortingCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchReviewImage(
            menuPairID: menuData?.menuPairID ?? 0,
            pageNumber: 0,
            pageSize: 3
        )
        fetchReviewInfo(
            menuPairID: menuData?.menuPairID ?? 0,
            pageNumber: 0,
            pageSize: pageSize,
            sortingCriteria: "BEST_MATCH",
            isWithImage: false
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateCollectionViewHeight()
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: - Action
        
        // MARK: - State
        
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setClearWhiteBackNaviBar()
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            menuReviewScrollView,
            shadowContainerView
        ].forEach(view.addSubview)
        
        [
            menuReviewStackView
        ].forEach(menuReviewScrollView.addSubview)
        
        [
            reviewSortingTableView
        ].forEach(shadowContainerView.addSubview)
        
        [
            menuDefaultImageView,
            menuReviewCollectionView,
            menuReviewListCollectionView
        ].forEach(menuReviewStackView.addArrangedSubview)
        
        menuReviewStackView.setCustomSpacing(0.5, after: menuReviewCollectionView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuReviewScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shadowContainerView.snp.makeConstraints {
            $0.top.equalTo(menuReviewCollectionView.snp.bottom)
            $0.trailing.equalToSuperview().inset(31)
            $0.width.equalTo(134)
            $0.height.equalTo(93)
        }
        
        menuReviewStackView.snp.makeConstraints {
            $0.edges.equalTo(menuReviewScrollView.contentLayoutGuide)
            $0.width.equalTo(menuReviewScrollView.frameLayoutGuide)
        }
        
        menuDefaultImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(272)
            $0.width.equalToSuperview()
        }
        
        menuReviewCollectionView.snp.makeConstraints {
            $0.height.equalTo(1000)
        }
        
        menuReviewListCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        reviewSortingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Set Shadow
    
    private func setShadow() {
        let shadowPath = UIBezierPath(roundedRect: shadowContainerView.bounds, cornerRadius: 10).cgPath

        if let firstLayer = shadowContainerView.layer.value(forKey: "firstLayerShadow") as? CALayer {
            firstLayer.shadowPath = shadowPath
            firstLayer.bounds = shadowContainerView.bounds
            firstLayer.position = CGPoint(x: shadowContainerView.bounds.midX, y: shadowContainerView.bounds.midY)
        }

        if let secondLayer = shadowContainerView.layer.value(forKey: "secondLayerShadow") as? CALayer {
            secondLayer.shadowPath = shadowPath
            secondLayer.bounds = shadowContainerView.bounds
            secondLayer.position = CGPoint(x: shadowContainerView.bounds.midX, y: shadowContainerView.bounds.midY)
        }
    }
    
    // MARK: - TableView Toggle
    
    private func toggleTableView() {
        isReviewSortingExpanded.toggle()
        
        UIView.animate(withDuration: 0.5) {
            self.shadowContainerView.isHidden = !self.isReviewSortingExpanded
        }
    }
    
    // MARK: - Bind Data
    
    func bindData(menu: HomeMenuModel) {
        self.menuData = menu
    }
    
    // MARK: - Update UICollectionView
    
    private func updateCollectionViewHeight() {
        DispatchQueue.main.async {
            self.menuReviewCollectionView.layoutIfNeeded() // 즉시 레이아웃(frame, bounds, contentSize 등) 계산
            self.menuReviewListCollectionView.layoutIfNeeded()
            
            // 콘텐츠 크기 기반으로 높이 계산
            let menuReviewCollectionViewHeight = self.menuReviewCollectionView.collectionViewLayout.collectionViewContentSize.height
            let menuReviewListCollectionViewHeight = self.menuReviewListCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            if menuReviewCollectionViewHeight != self.presentMenuReviewCollectionViewHeight {
                self.presentMenuReviewCollectionViewHeight = menuReviewCollectionViewHeight
                
                self.menuReviewCollectionView.snp.updateConstraints {
                    $0.height.equalTo(menuReviewCollectionViewHeight)
                }
            }
            
            if menuReviewListCollectionViewHeight != self.presentMenuReviewListCollectionViewHeight {
                self.presentMenuReviewListCollectionViewHeight = menuReviewListCollectionViewHeight
                
                self.menuReviewListCollectionView.snp.updateConstraints {
                    $0.height.equalTo(menuReviewListCollectionViewHeight)
                }
            }
        }
    }
    
    // MARK: - Configure CollectionView
    
    private func configure() {
        if let imageName = menuData?.menuImage, imageName != "DefaultMenuImage" {
            menuDefaultImageView.kf.setImage(with: URL(string: "\(baseURL.reviewImageURL)\(imageName)"))
        } else {
            menuDefaultImageView.image = UIImage(named: "MenuDetailDefaultMenuImage")
        }
    }
    
    // MARK: - Fetch API
    
    private func fetchReviewImage(menuPairID: Int, pageNumber: Int, pageSize: Int) {
        MenuDetailAPI.fetchReviewImageList(menuPairID: menuPairID, pageNumber: pageNumber, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let reviewInfo):
                DispatchQueue.main.async {
                    // 서버 데이터를 reviewImage에 저장
                    self.reviewImages = reviewInfo.reviewImageDetailList.map { $0.reviewImage }
                    self.menuReviewCollectionView.reloadSections(IndexSet([2]))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    // 에러 처리 (필요 시 UI에 에러 메시지 표시 가능)
                    print("Error fetching menu data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchReviewInfo(menuPairID: Int, pageNumber: Int, pageSize: Int, sortingCriteria: String, isWithImage: Bool) {
        // TODO: 로딩뷰 추가
        guard !isFetching else { return }
        isFetching = true
        
        MenuDetailAPI.fetchReviewInfo(menuPairID: menuPairID, pageNumber: pageNumber, pageSize: pageSize, sortingCriteria: sortingCriteria, isWithImage: isWithImage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                defer {
                    self.isFetching = false
                }
                
                switch result {
                case .success(let reviewInfo):
                    self.reviewData.append(contentsOf: reviewInfo.reviewList.map { review in
                            MenuDetailModel(
                                reviewID: review.reviewID,
                                reviewComment: review.comment,
                                reviewRating: review.reviewRating,
                                reviewImage: review.reviewImage,
                                reviewLikedCount: review.reviewLikeCount,
                                reviewCreatedDate: review.reviewCreatedDate.convertDateFormat(),
                                mainMenuName: review.mainMenuName,
                                subMenuName: review.subMenuName,
                                mainMenuID: review.mainMenuID,
                                subMenuID: review.subMenuID,
                                memberNickname: review.memberNickname,
                                memberImage: review.memberImage ?? "MenuDefaultImage",
                                isOwned: review.isOwned,
                                isMemberLikedReview: review.isMemberLikedReview
                            )
                        }
                    )
                    self.isLastPage = reviewInfo.isLastPage
                    self.menuReviewListCollectionView.reloadData()
                    
                case .failure(let error):
                    // TODO: 로딩 실패 UI
                    // 에러 처리 (필요 시 UI에 에러 메시지 표시 가능)
                    print("Error fetching menu data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Post API
    
    private func postIsMenuLike() {
        MenuDetailAPI.postIsMenuLiked(menuID: menuData?.mainMenuID ?? 0) { result in
            switch result {
            case .success(let isLiked):
                DispatchQueue.main.async {
                    self.menuData?.isLikedMenu = isLiked
                    
                    if let cell = self.menuReviewCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MenuHeader {
                        cell.updateMenuLikeButton(isMemberLikedReview: isLiked)
                    }
                }
            case .failure(let error):
                print("<< [MenuDetailVC] 메뉴 좋아요 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func postIsReviewLike(at indexPath: IndexPath) {
        MenuDetailAPI.postIsReviewLiked(reviewID: reviewData[indexPath.item].reviewID) { result in
            switch result {
            case .success(let isLiked):
                // TODO: 리뷰 좋아요 카운팅 손보기
                // TODO: 서버 요청 함수와 UI 업데이트 함수 분리하기
                DispatchQueue.main.async {
                    self.reviewData[indexPath.item].isMemberLikedReview = isLiked
                    
                    if isLiked {
                        self.reviewData[indexPath.item].reviewLikedCount += 1
                    } else {
                        self.reviewData[indexPath.item].reviewLikedCount = max(0, self.reviewData[indexPath.item].reviewLikedCount - 1)
                    }
                    let reviewLikeCount = self.reviewData[indexPath.item].reviewLikedCount
                    
                    if let reviewListCell = self.menuReviewCollectionView.cellForItem(at: indexPath) as? MenuReviewList {
                        let innerIndexPath = IndexPath(item: 0, section: 0)
                        
                        if let reviewListInfoCell = reviewListCell.reviewCollectionView.cellForItem(at: innerIndexPath) as? MenuReviewListInfo {
                            reviewListInfoCell.updateReviewLikeButton(
                                isReviewLiked: isLiked
                            )
                            reviewListInfoCell.updateReviewLikeCountLabel(reviewLikedCount: reviewLikeCount)
                        }
                    }
                }
                
            case .failure(let error):
                print("[MenuDetailVC] 리뷰 좋아요 실패: \(error.localizedDescription)")
            }
            
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return MenuDetailCollectionViewLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createMenuHeaderSection()    // 메뉴 정보 섹션
            case 1:
                return self.createMenuInfoSection() // 메뉴 구성 섹션
            case 2:
                return self.createReviewSection() // 리뷰 헤더 섹션 (가로 스크롤 사진 포함)
            case 3:
                return self.createReviewSortingSection() // 리뷰 정렬 섹션
            default:
                return nil
            }
        }
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .greatestFiniteMagnitude
        layout.sectionInset = .zero
        
        return layout
    }
    
    // MARK: - Create Section
    
    private func createMenuHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 41, leading: 23, bottom: 23, trailing: 23)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createMenuInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let menuCount = menuData?.restMenu?.count ?? 0
        let calculatedHeight = CGFloat((menuCount * 17) + 20 + 22 + 21) // calculatedHeight = 메뉴 높이(17 * 메뉴 개수) + 메뉴박스 위아래 공백(20) + 메뉴 헤더와의 간격(22) + 메뉴 헤더 높이(21)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(calculatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 23, bottom: 20, trailing: 23)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 23, bottom: 15, trailing: 23)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewSortingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 23)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
}

// MARK: - UICollectionView Extension

extension MenuDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == menuReviewCollectionView {
            return 4
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuReviewCollectionView {
            return 1
        } else {
            return reviewData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuReviewCollectionView {
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuHeader.reuseIdentifier, for: indexPath) as! MenuHeader
                cell.delegate = self
                cell.configureMenuHeader(
                    menuName: menuData?.menuName ?? "",
                    menuPrice: menuData?.menuPrice ?? ""
                )
                cell.updateMenuLikeButton(isMemberLikedReview: menuData?.isLikedMenu ?? false)
                
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuInfo.reuseIdentifier, for: indexPath) as! MenuInfo
                if let menuData = menuData {
                    cell.configureMenuInfo(with: menuData.restMenu ?? [])
                }
                
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReview.reuseIdentifier, for: indexPath) as! MenuReview
                cell.configureMenuReview(
                    menuReviewData: menuData
                        ?? HomeMenuModel(
                            menuName: "",
                            menuImage: "DefaultMenuImage",
                            menuPrice: "",
                            menuRating: 0.0,
                            cafeteriaName: "",
                            cafeteriaCorner: "",
                            isLikedMenu: false,
                            restMenu: [],
                            reviewCount: 0,
                            menuPairID: 0,
                            mainMenuID: 0,
                            subMenuID: 0
                        ),
                    reviewImages: reviewImages
                )
                
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewSorting.reuseIdentifier, for: indexPath) as! MenuReviewSorting
                cell.delegate = self
                cell.setUI(sortingCriteria: sortingOptions[selectedSortingIndex])
                
                return cell
            default:
                fatalError("Unexpected section")
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListCell.reuseIdentifier, for: indexPath) as! MenuReviewListCell
            let hashTags = [reviewData[indexPath.item].mainMenuName, reviewData[indexPath.item].subMenuName]
            let isHighlighted: [Bool] = [
                menuData?.mainMenuID == reviewData[indexPath.item].mainMenuID,
                menuData?.subMenuID == reviewData[indexPath.item].subMenuID
            ]
//            cell.configureMenuData(
//                with: menuData ?? HomeMenuModel(
//                    menuName: "",
//                    menuImage: "DefaultMenuImage",
//                    menuPrice: "",
//                    menuRating: 0.0,
//                    cafeteriaName: "",
//                    cafeteriaCorner: "",
//                    isLikedMenu: false,
//                    restMenu: [],
//                    reviewCount: 0,
//                    menuPairID: 0,
//                    mainMenuID: 0,
//                    subMenuID: 0
//                )
//            )
//            if indexPath.item < reviewData.count {
//                cell.configureMenuReviewList(with: reviewData[indexPath.item], indexPath: indexPath)
//            }
//            cell.configureMenuReviewList(with: reviewData[indexPath.item], indexPath: indexPath)
//            cell.delegate = self
            
            cell.configure(with: reviewData[indexPath.item])
            cell.bindHashTagData(hashTags: hashTags, isHighlighted: isHighlighted)
            cell.menuReviewInfoView.onLikeToggled = { [weak self, weak cell] isReviewLiked in
                guard let self = self else { return }
                
                // 일정 시간 안에 좋아요 버튼을 누르면 타이머 초기화
                self.reviewLikeDebounceTimers[indexPath.item]?.invalidate()
                
                // 일정 시간 뒤에 클로저 내부의 코드 실행
                let timer = Timer.scheduledTimer(withTimeInterval: self.reviewLikeDebounceInterval, repeats: false) { _ in
                    // 해당 리뷰에 관련된 타이머를 삭제
                    self.reviewLikeDebounceTimers[indexPath.item] = nil

                    if isReviewLiked {
                        print("<< 좋아요 누름")
                    } else {
                        print("<< 좋아요 취소 누름")
                    }
                }
                // 각 리뷰별 타이머 저장
                self.reviewLikeDebounceTimers[indexPath.item] = timer
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SeparatingLineView.reuseIdentifier,
                for: indexPath
            ) as! SeparatingLineView
            
            // footer Style 지정
            footer.configureLineView(.menuDetail)
            
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - UIScrollView Extension

extension MenuDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavigationBarVisibility(scrollView)
        updateCollectionViewHeightUpdateIfNeeded(scrollView)
        loadNextPageIfNeeded(scrollView)
    }
    
    private func updateNavigationBarVisibility(_ scrollView: UIScrollView) {
        let currentScrollLocation = scrollView.contentOffset.y  // 현재 스크롤 위치

        if currentScrollLocation > 50, !isNavigationBarHidden {
            navigationController?.setNavigationBarHidden(true, animated: true)
            isNavigationBarHidden = true
        } else if currentScrollLocation <= 50, isNavigationBarHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
            isNavigationBarHidden = false
        }
    }

    private func updateCollectionViewHeightUpdateIfNeeded(_ scrollView: UIScrollView) {
        let currentScrollLocation = scrollView.contentOffset.y      // 현재 스크롤 위치
        let contentHeight = scrollView.contentSize.height           // 스크롤 가능한 전체 콘텐츠 높이
        let frameHeight = scrollView.frame.size.height              // 스크롤뷰가 차지하는 실제 UI 높이
        
        let threshold = UIScreen.main.bounds.height * 0.1
        let isNearBottom = currentScrollLocation > contentHeight - frameHeight - threshold
        
        let now = Date()
        let elapsed = now.timeIntervalSince(lastHeightUpdateTime)
        
        if isNearBottom && elapsed >= heightUpdateInterval {
            // TODO: 빠르게 스크롤할 경우를 대비한 1초(로딩 시간은 미정)짜리 로딩 UI 추가
            lastHeightUpdateTime = now
            updateCollectionViewHeight()
        }
    }

    private func loadNextPageIfNeeded(_ scrollView: UIScrollView) {
        // TODO: 다음 페이지 로딩도 debounce말고 throttle 써야되는거 아닌가? 사용자가 0.1초를 기다리지 않고 계속 아래로 스크롤 행위를 하면 타이머가 계속 초기화되면서 무한 기다림 아님?
        
        scrollDebounceTimer?.invalidate()
        scrollDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            guard !isFetching, !isLastPage else { return }
            
            let currentScrollLocation = scrollView.contentOffset.y      // 현재 스크롤 위치
            let contentHeight = scrollView.contentSize.height           // 스크롤 가능한 전체 콘텐츠 높이
            let frameHeight = scrollView.frame.size.height              // 스크롤뷰가 차지하는 실제 UI 높이
            
            let threshold = UIScreen.main.bounds.height * 0.1
            let isNearBottom = currentScrollLocation > contentHeight - frameHeight - threshold
            
            if isNearBottom {
                currentPageNumber += 1
                // TODO: 로딩뷰 추가
                fetchReviewInfo(
                    menuPairID: menuData?.menuPairID ?? 0,
                    pageNumber: currentPageNumber,
                    pageSize: pageSize,
                    sortingCriteria: sortingCriteria,
                    isWithImage: isOnlyPhotoChecked
                )
            }
        }
    }
}

// MARK: - UITableView Extension

extension MenuDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuReviewSortingCell.reuseIdentifier, for: indexPath) as! MenuReviewSortingCell
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

        cell.selectionStyle = .none
        cell.configureMenuReviewSortingCell(
            sortingCriteria: sortingOptions[indexPath.row],
            isSelected: indexPath.row == selectedSortingIndex
        )
        cell.hideSeparator(isLastCell)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 31
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleTableView()
        selectedSortingIndex = indexPath.row

        let sortingCriteria: String

        switch selectedSortingIndex {
        case 0:
            sortingCriteria = "BEST_MATCH"
        case 1:
            sortingCriteria = "MOST_LIKED"
        default:
            sortingCriteria = "NEWEST_FIRST"
        }
        
        /// 애니메이션이 필요할 경우
//        menuReviewCollectionView.performBatchUpdates({
//            menuReviewCollectionView.reloadSections(IndexSet(integer: 3))
//        }, completion: { _ in
//            self.updateCollectionViewHeight()
//        })
        
        /// 애니메이션이 필요하지 않은 경우
        UIView.performWithoutAnimation {
            menuReviewCollectionView.reloadSections(IndexSet(integer: 3))
            menuReviewCollectionView.layoutIfNeeded()
        }
        updateCollectionViewHeight()
        
        reviewData.removeAll()
        // TODO: 로딩뷰 추가 - 현재는 로딩되는 동안 흰색 화면 나와서 화면 깜빡이는 것처럼 보임.
        DispatchQueue.main.async {
            self.menuReviewListCollectionView.reloadData()
        }
        
        self.sortingCriteria = sortingCriteria
        currentPageNumber = 0
        isLastPage = false
        isFetching = false
        
        fetchReviewInfo(
            menuPairID: menuData?.menuPairID ?? 0,
            pageNumber: currentPageNumber,
            pageSize: pageSize,
            sortingCriteria: self.sortingCriteria,
            isWithImage: isOnlyPhotoChecked
        )
        
        tableView.reloadData()
    }
}

// MARK: - MenuHeader Delegate

extension MenuDetailViewController: MenuHeaderDelegate {
    func didTapMenuLikeButton() {
        postIsMenuLike()
    }
}

// MARK: - MenuReviewSorting Delegate

extension MenuDetailViewController: MenuReviewSortingDelegate {
    func didTapOnlyPhotoReview(isOnlyPhotoChecked: Bool) {
        self.isOnlyPhotoChecked = isOnlyPhotoChecked
        self.reviewData.removeAll()
        // TODO: 로딩뷰 추가 - 현재는 로딩되는 동안 흰색 화면 나와서 화면 깜빡이는 것처럼 보임.
        DispatchQueue.main.async {
            self.menuReviewListCollectionView.reloadData()
        }
        
        self.currentPageNumber = 0
        self.isLastPage = false
        self.isFetching = false
        
        fetchReviewInfo(
            menuPairID: menuData?.menuPairID ?? 0,
            pageNumber: currentPageNumber,
            pageSize: pageSize,
            sortingCriteria: sortingCriteria,
            isWithImage: self.isOnlyPhotoChecked
        )
    }
    
//    func didReviewSort(sortingCriteria: String) {
//        self.sortingCriteria = sortingCriteria
//
//        fetchReviewInfo(
//            menuPairID: menuData?.menuPairID ?? 0,
//            pageNumber: currentPageNumber,
//            pageSize: pageSize,
//            sortingCriteria: sortingCriteria,
//            isWithImage: isOnlyPhotoChecked
//        )
//    }
    
    func didTapReviewSort() {
        toggleTableView()

        if isReviewSortingExpanded {
            setShadow()
        }
    }
}

// MARK: - MenuReviewList Delegate

extension MenuDetailViewController: MenuReviewListInfoDelegate {
    func didTapReviewLike(at indexPath: IndexPath) {
        postIsReviewLike(at: indexPath)
    }
}
