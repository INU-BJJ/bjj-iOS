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
        $0.register(MenuReviewList.self, forCellWithReuseIdentifier: MenuReviewList.reuseIdentifier)
        $0.register(SeparatingLineView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeparatingLineView.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
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
        
        // 즉시 레이아웃(frame, bounds, contentSize 등) 계산
        menuReviewCollectionView.layoutIfNeeded()
        updateCollectionView()
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
            menuReviewCollectionView
        ].forEach(menuReviewStackView.addArrangedSubview)
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
    }
    
    // MARK: - Bind Data
    
    func bindData(menu: HomeMenuModel) {
        self.menuData = menu
    }
    
    // MARK: - Update UICollectionView
    
    private func updateCollectionView() {
        // 콘텐츠 크기 기반으로 높이 계산
        let collectionViewContentHeight = menuReviewCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        // 컬렉션 뷰 높이 업데이트
        menuReviewCollectionView.snp.updateConstraints {
            $0.height.equalTo(collectionViewContentHeight)
        }
    }
    
    // MARK: - Configure CollectionView
    
    private func configure() {
        if let imageName = menuData?.menuImage, imageName != "DefaultMenuImage" {
            menuDefaultImageView.kf.setImage(with: URL(string: "\(baseURL.imageURL)\(imageName)"))
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
                                reviewComment: review.comment,
                                reviewRating: review.reviewRating,
                                reviewImage: review.reviewImage,
                                reviewLikedCount: review.reviewLikeCount,
                                reviewCreatedDate: review.reviewCreatedDate.convertDateFormat(),
                                mainMenuName: review.mainMenuName,
                                subMenuName: review.subMenuName,
                                memberNickname: review.memberNickname,
                                memberImage: review.memberImage ?? "MenuDefaultImage",
                                isMemberLikedReview: review.isMemberLikedReview
                            )
                        }
                    )
                    self.isLastPage = reviewInfo.isLastPage
                    self.menuReviewCollectionView.layoutIfNeeded() // 즉시 레이아웃(frame, bounds, contentSize 등) 계산
                    self.updateCollectionView()
                    self.menuReviewCollectionView.reloadSections(IndexSet([4])) // 컬렉션 뷰 업데이트
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
            case 4:
                return self.createReviewListSection()   // 리뷰 리스트 섹션
            default:
                return nil
            }
        }
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
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 41, leading: 24, bottom: 23, trailing: 24)
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
        
        // TODO: 피그마에선 좌 46, 우 45로 설정되어 있어서 질문
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 24, bottom: 16, trailing: 24)
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
    
    private func createReviewListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // TODO: 리뷰 글의 줄 수에 따라 높이 동적 조절
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(413))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

extension MenuDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1      // 메뉴 정보는 하나의 셀만 필요
        case 1:
            return 1      // 메뉴 구성도 하나의 셀로 표시
        case 2:
            return 1      // 리뷰 헤더도 하나의 셀로 구성
        case 3:
            return 1
        case 4:
            return reviewData.isEmpty ? 0 : reviewData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuHeader.reuseIdentifier, for: indexPath) as! MenuHeader
            cell.configureMenuHeader(
                menuName: menuData?.menuName ?? "",
                menuPrice: menuData?.menuPrice ?? "",
                isMemberLikedReview: menuData?.isLikedMenu ?? false
            )
            
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
                        menuPairID: 0
                    ),
                reviewImages: reviewImages
            )
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewSorting.reuseIdentifier, for: indexPath) as! MenuReviewSorting
            cell.delegate = self
            
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewList.reuseIdentifier, for: indexPath) as! MenuReviewList
            cell.configureMenuReviewList(with: reviewData[indexPath.item])
            
            return cell
        default:
            fatalError("Unexpected section")
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
            
            // 마지막 섹션에는 구분선을 표시하지 않을 경우
            footer.isHidden = indexPath.section == 4
            
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - UIScrollView Extension

extension MenuDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentScrollLoacation = scrollView.contentOffset.y     // 현재 스크롤 위치
        let contentHeight = scrollView.contentSize.height           // 스크롤 가능한 전체 콘텐츠 높이
        let frameHeight = scrollView.frame.size.height              // 스크롤뷰가 차지하는 실제 UI 높이
                
        if currentScrollLoacation > 50, !isNavigationBarHidden {
            // 아래로 스크롤하면 네비게이션 바 숨김
            navigationController?.setNavigationBarHidden(true, animated: true)
            isNavigationBarHidden = true
        } else if currentScrollLoacation <= 50, isNavigationBarHidden {
            // 위로 스크롤하거나 초기 상태로 돌아오면 네비게이션 바 표시
            navigationController?.setNavigationBarHidden(false, animated: true)
            isNavigationBarHidden = false
        }
        
        // 서버 데이터 fetch하고 있지 않고, 마지막 페이지가 아닐 때만 데이터 재요청
        if !isFetching, !isLastPage {
            // 현재 스크롤 위치와 로드해놓은 콘텐츠의 아랫면과 가까워지면
            if currentScrollLoacation > contentHeight - frameHeight - UIScreen.main.bounds.height * 0.1 && !isLastPage {
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
