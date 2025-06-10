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
    
    private let reviewPhotos = ["924947b4-c7a1-4d9f-8026-6d653366d100.jpeg", "4e61e349-e412-4783-8432-d4c9d9ff1162.jpeg", "8f1a719b-5559-49f4-8c2b-d62edf3bc3ea.jpeg"]
    
    // MARK: - UI Components
    
    private lazy var reviewPhotosCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    ).then {
        $0.register(ReviewPhotoCell.self, forCellWithReuseIdentifier: ReviewPhotoCell.reuseIdentifier)
        $0.dataSource = self
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
            $0.bottom.equalToSuperview().inset(150)
        }
    }
    
    // MARK: - Create Layout
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            // 아이템 설정
            // TODO: 아이템 크기 수정
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .absolute(75)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 그룹 설정
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(75)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
            // TODO: 간격 수정
            group.interItemSpacing = .fixed(10)
            
            // 섹션 설정
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none

            return section
        }
    }
}

extension ReviewPhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reviewPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPhotoCell.reuseIdentifier, for: indexPath) as! ReviewPhotoCell
        cell.setUI(reviewPhoto: reviewPhotos[indexPath.item])
        
        return cell
    }
}
