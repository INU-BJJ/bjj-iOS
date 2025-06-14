//
//  ReviewPhotoGalleryViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/9/25.
//

import UIKit
import SnapKit
import Then

final class ReviewPhotoGalleryViewController: UIViewController {

    // MARK: - Properties
    
    private var fetchCancelToken: APICancelToken?
    private var dataSource: UICollectionViewDiffableDataSource<ReviewPhotoGallerySection, ReviewPhotoGalleryItem>?
    private var menuPairID: Int
    
    private var currentPageNumber = 0
    private let pageSize = 18
    private let columnCount = 3
    
    private var isLastPage = false
    private var isFetching = false
    
    private var lastHeightUpdateTime: Date = .distantPast
    private let heightUpdateInterval: TimeInterval = 1
    
    private var canFetchNextPage: Bool {
        guard !isFetching, !isLastPage else { return false }
        
        let now = Date()
        let elapsed = now.timeIntervalSince(lastHeightUpdateTime)
        guard elapsed >= heightUpdateInterval else { return false }
        
        return true
    }
    
    // MARK: - UI Components
    
    private lazy var reviewPhotosCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    ).then {
        $0.register(ReviewPhotoCell.self, forCellWithReuseIdentifier: ReviewPhotoCell.reuseIdentifier)
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - LifeCycle
    
    init(menuPairID: Int) {
        self.menuPairID = menuPairID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataSource?.snapshot().itemIdentifiers.isEmpty == true {
            fetchReviewPhotos(menuPairID: menuPairID, pageNumber: currentPageNumber, pageSize: pageSize)
        }
    }
    
    deinit {
        fetchCancelToken?.cancel()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
        setBackNaviBar("리뷰 사진 모아보기")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            reviewPhotosCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewPhotosCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchReviewPhotos(menuPairID: Int, pageNumber: Int, pageSize: Int) {
        fetchCancelToken?.cancel()
        
        let token = APICancelToken()
        self.fetchCancelToken = token
        
        
        MenuDetailAPI.fetchReviewImageList(
            menuPairID: menuPairID,
            pageNumber: pageNumber,
            pageSize: pageSize,
            cancelToken: token) { result in
                defer {
                    self.isFetching = false
                }
                
                // TODO: 로딩 UI 추가
//                https://blog.rightbrain.co.kr/?p=12479
                
                switch result {
                case .success(let responseData):
                    let reviewPhotos = responseData.reviewImageDetailList.map { $0.reviewImage }
                    
                    DispatchQueue.main.async {
                        self.isLastPage = responseData.isLastPage
                        self.updateSnapshot(forSection: .reviewPhotos, withItems: reviewPhotos)
                    }
                    
                case .failure(let error):
                    print("[ReviewPhotoGallery] Error: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Create Layout
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            // 아이템 설정
            // TODO: 아이템 크기 수정
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .absolute(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 그룹 설정
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(200)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: self.columnCount
            )
            // TODO: 간격 수정
            group.interItemSpacing = .fixed(10)
            
            // 섹션 설정
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.orthogonalScrollingBehavior = .none

            return section
        }
    }
    
    // MARK: - Configure DataSource
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ReviewPhotoGallerySection, ReviewPhotoGalleryItem>(collectionView: reviewPhotosCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: ReviewPhotoGalleryItem) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPhotoCell.reuseIdentifier, for: indexPath) as? ReviewPhotoCell else {
                return UICollectionViewCell()
            }
            
            switch item {
            case .photoURL(let photoURL):
                cell.setUI(reviewPhoto: photoURL)
            }
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ReviewPhotoGallerySection, ReviewPhotoGalleryItem>()
        snapshot.appendSections([.reviewPhotos])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Update Snapshot
    
    private func updateSnapshot(forSection section: ReviewPhotoGallerySection, withItems reviewPhotos: [String]) {
        guard let dataSource = self.dataSource else { return }
        var snapshot = dataSource.snapshot()
        let items = reviewPhotos.map { ReviewPhotoGalleryItem.photoURL($0) }
        
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ReviewPhotoGalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
            // 마지막 2줄이 화면에 나타날 때 다음 페이지 이미지 로드
            let triggerIndex = dataSource?.snapshot().numberOfItems ?? 0 - (self.columnCount * 2)
            let needsNextPage = indexPath.item >= max(0, triggerIndex)
            
            if needsNextPage && canFetchNextPage {
                isFetching = true
                lastHeightUpdateTime = Date()
                currentPageNumber += 1
                
                fetchReviewPhotos(
                    menuPairID: menuPairID,
                    pageNumber: currentPageNumber,
                    pageSize: pageSize
                )
            }
    }
}

//extension ReviewPhotoGalleryViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        prefetchItemsAt indexPaths: [IndexPath]) {
//            let needsNextPage = indexPaths.contains { $0.item >= max(dataSource?.snapshot().numberOfItems ?? 0 - 3, 0) }
//            
//            if needsNextPage && canFetchNextPage {
//                isFetching = true
//                lastHeightUpdateTime = Date()
//                currentPageNumber += 1
//            
//                fetchReviewPhotos(
//                    menuPairID: menuPairID,
//                    pageNumber: currentPageNumber,
//                    pageSize: pageSize
//                )
//            }
//    }
//}
