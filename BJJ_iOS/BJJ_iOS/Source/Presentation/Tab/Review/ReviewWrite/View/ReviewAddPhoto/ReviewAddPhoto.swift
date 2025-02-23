//
//  ReviewAddPhoto.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit
import SnapKit
import Then

final class ReviewAddPhoto: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var reviewImages: [String] = []
    
    // MARK: - UI Components
    
    private lazy var reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(ReviewAddPhotoCell.self, forCellWithReuseIdentifier: ReviewAddPhotoCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
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
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            reviewImageCollectionView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewImageCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // TODO: 피그마에서 고정 너비를 75로 할 경우, 마지막 셀의 오른쪽이 잘려보임. 텍스트뷰의 trailing은 20, 사진첨부 셀의 trailing은 19를 의도했는지 질문.
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 18
        // TODO: 가로 스크롤 비활성화
        section.orthogonalScrollingBehavior = .paging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ReviewAddPhoto: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImages.count < 4 ? reviewImages.count + 1 : reviewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewAddPhotoCell.reuseIdentifier, for: indexPath) as! ReviewAddPhotoCell
        
        if indexPath.item < reviewImages.count {
            cell.configureAddPhotoCell(with: reviewImages[indexPath.item])
        } else {
            cell.configureAddPhotoCell(with: nil)
        }
        
        return cell
    }
    
    // TODO: 이미지 버튼 선택 시 동작
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        presentImagePicker(for: indexPath.item)
//    }
}
