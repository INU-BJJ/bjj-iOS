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
            menuReviewScrollView
        ].forEach(view.addSubview)
        
        [
            menuReviewStackView
        ].forEach(menuReviewScrollView.addSubview)
        
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
        MenuDetailAPI.fetchReviewInfo(menuPairID: menuPairID, pageNumber: pageNumber, pageSize: pageSize, sortingCriteria: sortingCriteria, isWithImage: isWithImage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let reviewInfo):
                DispatchQueue.main.async {
                    // 서버 데이터를 reviewData에 저장
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
                    self.isFetching = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
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
        let calculatedHeight = CGFloat((menuCount * 17) + 20 + 22 + 15) // calculatedHeight = 메뉴 높이(17 * 메뉴 개수) + 메뉴박스 위아래 공백(20) + 메뉴 헤더와의 간격(22) + 메뉴 헤더 높이(15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(calculatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 23, bottom: 16, trailing: 23)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(104))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 24, bottom: 17, trailing: 24)
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
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
}

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

        if isNearBottom {
            updateCollectionViewHeight()
        }
    }

    private func loadNextPageIfNeeded(_ scrollView: UIScrollView) {
        guard !isFetching, !isLastPage else { return }

        let currentScrollLocation = scrollView.contentOffset.y      // 현재 스크롤 위치
        let contentHeight = scrollView.contentSize.height           // 스크롤 가능한 전체 콘텐츠 높이
        let frameHeight = scrollView.frame.size.height              // 스크롤뷰가 차지하는 실제 UI 높이

        let threshold = UIScreen.main.bounds.height * 0.1
        let isNearBottom = currentScrollLocation > contentHeight - frameHeight - threshold

        if isNearBottom {
            currentPageNumber += 1
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
        
        fetchReviewInfo(
            menuPairID: menuData?.menuPairID ?? 0,
            pageNumber: currentPageNumber,
            pageSize: pageSize,
            sortingCriteria: sortingCriteria,
            isWithImage: isOnlyPhotoChecked
        )
    }
    
    func didReviewSort(sortingCriteria: String) {
        self.sortingCriteria = sortingCriteria
        
        fetchReviewInfo(
            menuPairID: menuData?.menuPairID ?? 0,
            pageNumber: currentPageNumber,
            pageSize: pageSize,
            sortingCriteria: sortingCriteria,
            isWithImage: isOnlyPhotoChecked
        )
    }
}

// MARK: - MenuReviewList Delegate

extension MenuDetailViewController: MenuReviewListInfoDelegate {
    func didTapReviewLike(at indexPath: IndexPath) {
        postIsReviewLike(at: indexPath)
    }
}
