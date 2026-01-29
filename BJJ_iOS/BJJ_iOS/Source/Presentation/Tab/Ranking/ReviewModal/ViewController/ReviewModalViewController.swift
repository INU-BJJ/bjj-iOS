//
//  ReviewModalViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class ReviewModalViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var bestReviewID: Int
    private var reviewImages: [String] = []
    private let modalStackViewTapGesture = UITapGestureRecognizer()
    
    // MARK: - UI Components
    
    private lazy var reviewModalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
        $0.backgroundColor = .white
        $0.layoutMargins = UIEdgeInsets(top: 17, left: 14, bottom: 17, right: 14)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 17
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(modalStackViewTapGesture)
    }
    
    private let reviewInfoView = ReviewInfoView()
    
    private let reviewTextLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
        $0.setLineSpacing(kernValue: 0.13, lineHeightMultiple: 1.1)
        $0.numberOfLines = 3
        $0.lineBreakMode = .byWordWrapping
    }
    
    private lazy var reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createImageLayout()
    ).then {
        $0.register(ReviewModalImageCell.self, forCellWithReuseIdentifier: ReviewModalImageCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
    }
    
    // MARK: - LifeCycle
    
    init(bestReviewID: Int) {
        self.bestReviewID = bestReviewID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBestReview(bestReviewID: bestReviewID)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        let tapGestureInView = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        tapGestureInView.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGestureInView)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            reviewModalStackView
        ].forEach(view.addSubview)
        
        [
            reviewInfoView,
            reviewTextLabel,
            reviewImageCollectionView
        ].forEach(reviewModalStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        reviewModalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(169)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewInfoView.snp.makeConstraints {
            $0.height.equalTo(41)
        }
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.height.equalTo(283)
        }
    }
    
    // MARK: - Bind

    override func bind() {
        
        // 모달 창 탭
        modalStackViewTapGesture.rx.event
            .bind(with: self) { owner, _ in
                let presentingVC = owner.presentingViewController
                
                // dismiss 이후 리뷰 상세 페이지로 이동
                owner.dismiss(animated: true) {
                    // presentingViewController를 통해 실제 presenting하는 VC 찾기
                    var targetVC: UIViewController?
                    
                    if let navController = presentingVC as? UINavigationController {
                        targetVC = navController.viewControllers.last
                    } else if let tabBarController = presentingVC as? UITabBarController {
                        if let navController = tabBarController.selectedViewController as? UINavigationController {
                            targetVC = navController.viewControllers.last
                        }
                    } else {
                        targetVC = presentingVC
                    }
                    
                    // push 실행
                    if targetVC != nil {
                        targetVC?.presentMyReviewDetailViewController(reviewID: owner.bestReviewID)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Create Layout
    
    private func createImageLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // TODO: absolute 없애기
            // TODO: 너비가 이전에 쓰던 것과 달라져서 업데이트 하기
            let absoluteItemWidth: CGFloat
            let absoluteGroupWidth: CGFloat
            
            switch self.reviewImages.count {
            case 1:
                absoluteItemWidth = 301
                absoluteGroupWidth = 301
            case 2:
                absoluteItemWidth = 149.5
                absoluteGroupWidth = 301
            case 3:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 426.16
            case 4:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 568.88
            case 5:
//                fractionalWidth = 0.4738047138
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 711.59
            default:
//                absoluteItemWidth = 1.0
                absoluteItemWidth = 140.72
                absoluteGroupWidth = 301
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(absoluteItemWidth), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(absoluteGroupWidth), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
    
    // MARK: - Objc Function
    
    @objc private func dismissModal(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
            
        if !reviewModalStackView.frame.contains(touchPoint) {
            dismiss(animated: true)
        }
    }
    
    // MARK: - API Function
    
    private func fetchBestReview(bestReviewID: Int) {
        ReviewModalAPI.fetchBestReview(bestReviewID: bestReviewID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let bestReview):
                let bestReviewData = BestReviewSection(
                    reviewID: bestReview.reviewID,
                    comment: bestReview.comment,
                    reviewRating: bestReview.reviewRating,
                    reviewImages: bestReview.reviewImages,
                    reviewLikeCount: bestReview.reviewLikeCount,
                    reviewCreatedDate: bestReview.reviewCreatedDate,
                    menuPairID: bestReview.menuPairID,
                    mainMenuName: bestReview.mainMenuName,
                    subMenuName: bestReview.subMenuName,
                    memberID: bestReview.memberID,
                    memberNickname: bestReview.memberNickname,
                    memberImage: bestReview.memberImage ?? "",
                    isOwned: bestReview.isOwned,
                    isLiked: bestReview.isLiked
                )
                
                DispatchQueue.main.async {
                    self.reviewInfoView.setView(with: bestReviewData)
                    self.reviewTextLabel.text = bestReviewData.comment
                    self.reviewImages = bestReviewData.reviewImages
                    self.reviewImageCollectionView.isHidden = self.reviewImages.isEmpty
                    self.reviewImageCollectionView.reloadData()
                }
                
            case .failure(let error):
                self.presentAlertViewController(alertType: .failure, title: error.localizedDescription)
            }
        }
    }
}

extension ReviewModalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewModalImageCell.reuseIdentifier, for: indexPath) as! ReviewModalImageCell
        var cornerStyle: UIRectCorner = []
        
        if reviewImages.count > 1 {
            if indexPath.row == 0 {
                cornerStyle = [.topLeft, .bottomLeft]
            } else if indexPath.row == reviewImages.count - 1 {
                cornerStyle = [.topRight, .bottomRight]
            }
        } else {
            cornerStyle = [.allCorners]
        }

        cell.configureReviewImageCell(with: reviewImages[indexPath.row], cornerStyle: cornerStyle)
        
        return cell
    }
}
