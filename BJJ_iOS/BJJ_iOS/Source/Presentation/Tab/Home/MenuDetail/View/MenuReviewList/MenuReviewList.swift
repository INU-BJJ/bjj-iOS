//
//  MenuReviewList.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewList: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: MenuReviewListInfoDelegate?
    private var menuData: HomeMenuModel?
    private var menuReview: MenuDetailModel =
        MenuDetailModel(
            reviewID: 0,
            reviewComment: "",
            reviewRating: 0,
            reviewImage: nil,
            reviewLikedCount: 0,
            reviewCreatedDate: "",
            mainMenuName: "",
            subMenuName: "",
            mainMenuID: 0,
            subMenuID: 0,
            memberNickname: "",
            memberImage: "",
            isOwned: false,
            isMemberLikedReview: false
        )
    
    // MARK: - UI Components
    
    lazy var reviewCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(MenuReviewListInfo.self, forCellWithReuseIdentifier: MenuReviewListInfo.reuseIdentifier)
            $0.register(MenuReviewListContent.self, forCellWithReuseIdentifier: MenuReviewListContent.reuseIdentifier)
            $0.register(MenuReviewListHashTag.self, forCellWithReuseIdentifier: MenuReviewListHashTag.reuseIdentifier)
            $0.register(MenuReviewSeparatingView.self, forCellWithReuseIdentifier: MenuReviewSeparatingView.reuseIdentifier)
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            reviewCollectionView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuData(with menuData: HomeMenuModel) {
        self.menuData = menuData
    }
    
    func configureMenuReviewList(with menuReview: MenuDetailModel, indexPath: IndexPath) {
        self.menuReview = menuReview
        
        DispatchQueue.main.async {
            if let infoCell = self.reviewCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MenuReviewListInfo {
                infoCell.setIndexPath(indexPath: indexPath)
            }
            self.reviewCollectionView.reloadData()
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createMenuReviewListInfoSection()
            case 1:
                return self.createMenuReviewListContentSection()
            case 2:
                return self.createMenuReviewListHashTagSection()
            case 3:
                return self.createMenuReviewSeparatingSection()
            default:
                return nil
            }
        }
    }
    
    private func createMenuReviewListInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(41))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(41))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 46, bottom: 0, trailing: 46)
        
        return section
    }
    
    private func createMenuReviewListContentSection() -> NSCollectionLayoutSection {
        var calculatedHeight: CGFloat = 0.0

        let reviewLines = menuReview.reviewComment.reduce(0) { $0 + ($1 == "\n" ? 1 : 0) } + 1
        
        // 리뷰의 이미지 개수에 따라 높이 계산
        if let images = menuReview.reviewImage, images.isEmpty {
            // 이미지가 없을 때
            calculatedHeight = CGFloat(17 * reviewLines + 12)
        } else {
            // 이미지가 있을 때
            calculatedHeight = CGFloat(17 * reviewLines + 250 + 24)
        }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(calculatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 46, bottom: 0, trailing: 46)
        
        return section
    }
    
    private func createMenuReviewListHashTagSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 46, bottom: 17, trailing: 46)
        
        return section
    }
    
    private func createMenuReviewSeparatingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(7))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

extension MenuReviewList: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Info Section에 1개의 셀
        case 1:
            return 1 // Content Section에 1개의 셀
        case 2:
            return 1 // HashTag Section에 2개의 셀
        case 3:
            return 1 // SeparatingView 1개의 셀
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        // 프로필 이미지, 닉네임, 평점, 날짜, 좋아요 섹션
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListInfo.reuseIdentifier, for: indexPath) as! MenuReviewListInfo
            cell.configureReviewListInfo(with: menuReview)
            cell.updateReviewLikeButton(
                isReviewLiked: menuReview.isMemberLikedReview
            )
            cell.updateReviewLikeCountLabel(reviewLikedCount: menuReview.reviewLikedCount)
            cell.delegate = self
            
            return cell
        // 리뷰 글, 사진 섹션
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListContent.reuseIdentifier, for: indexPath) as! MenuReviewListContent
            cell.configureReviewListContent(with: menuReview)
            
            return cell
        // 메뉴 해시태그 섹션
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewListHashTag.reuseIdentifier, for: indexPath) as! MenuReviewListHashTag
            let isHighlighted: [Bool] = [
                menuData?.mainMenuID == menuReview.mainMenuID,
                menuData?.subMenuID == menuReview.subMenuID
            ]
            
            cell.bindHashTagData(
                hashTags: [menuReview.mainMenuName, menuReview.subMenuName],
                isHighlighted: isHighlighted
            )
            
            return cell
        // 구분선 섹션
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuReviewSeparatingView.reuseIdentifier, for: indexPath) as! MenuReviewSeparatingView
            
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}

extension MenuReviewList: MenuReviewListInfoDelegate {
    func didTapReviewLike(at indexPath: IndexPath) {
        delegate?.didTapReviewLike(at: indexPath)
    }
}
