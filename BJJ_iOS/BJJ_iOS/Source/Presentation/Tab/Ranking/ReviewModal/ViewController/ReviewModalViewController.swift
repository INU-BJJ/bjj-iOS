//
//  ReviewModalViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class ReviewModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let reviewImages: [String] = ["MenuImage2"]
    
    // MARK: - UI Components
    
    private let reviewModalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
        $0.backgroundColor = .white
        $0.layoutMargins = UIEdgeInsets(top: 17, left: 14, bottom: 17, right: 14)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 17
    }
    
    private let reviewInfoView = ReviewInfoView()
    
    private let reviewTextLabel = UILabel().then {
        $0.setLabelUI("핫도그는 냉동인데\n떡볶이는 맛있음\n맛도 있고 가격도 착해서 떡볶이 땡길 때 추천", font: .pretendard_medium, size: 13, color: .black)
        $0.setLineSpacing(kernValue: 0.13, lineHeightMultiple: 1.1)
        $0.numberOfLines = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
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
    
    private func setConstraints() {
        reviewModalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(226)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(108)
        }
        
        reviewInfoView.snp.makeConstraints {
            $0.height.equalTo(41)
        }
        
        reviewImageCollectionView.snp.makeConstraints {
            $0.height.equalTo(283)
        }
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
