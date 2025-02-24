//
//  ReviewWriteViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/7/25.
//

import UIKit
import SnapKit
import Then
import PhotosUI

final class ReviewWriteViewController: UIViewController, ReviewAddPhotoDelegate {
    
    // MARK: - Properties
    
    private var selectedPhotos: [UIImage] = []
    private let maxPhotoCount = 4
    
    // MARK: - UI Components
    
    private lazy var reviewWriteCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(ReviewCategorySelect.self, forCellWithReuseIdentifier: ReviewCategorySelect.reuseIdentifier)
        $0.register(ReviewRatingCell.self, forCellWithReuseIdentifier: ReviewRatingCell.reuseIdentifier)
        $0.register(ReviewContentCell.self, forCellWithReuseIdentifier: ReviewContentCell.reuseIdentifier)
        $0.register(ReviewAddPhoto.self, forCellWithReuseIdentifier: ReviewAddPhoto.reuseIdentifier)
        $0.register(ReviewGuidelines.self, forCellWithReuseIdentifier: ReviewGuidelines.reuseIdentifier)
        $0.register(SeparatingLineView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeparatingLineView.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let submitReviewButton = UIButton().makeConfirmButton(type: .submitReview)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("리뷰 작성하기")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            reviewWriteCollectionView,
            submitReviewButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewWriteCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(152)
        }
        
        submitReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(55)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createCategorySelectSection()
            case 1:
                return self.createReviewRatingSection()
            case 2:
                return self.createReviewContentSection()
            case 3:
                return self.createReviewAddPhotoSection()
            case 4:
                return self.createReviewGuidelineSection()
            default:
                return nil
            }
        }
    }
    
    // MARK: - Create Section
    
    private func createCategorySelectSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(114))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        // TODO: 다른 셀과의 간격 조정
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createReviewRatingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(58.27))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 24.73, trailing: 0)
        
        return section
    }
    
    private func createReviewContentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(184))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
        
        return section
    }
    
    private func createReviewAddPhotoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0)
        
        return section
    }
    
    private func createReviewGuidelineSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    // MARK: - didTapAddPhoto
    
    func didTapAddPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = maxPhotoCount
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ReviewWriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCategorySelect.reuseIdentifier, for: indexPath) as! ReviewCategorySelect
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewRatingCell.reuseIdentifier, for: indexPath) as! ReviewRatingCell
            cell.configureReviewRatingCell(reviewRating: 4, type: .big)
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewContentCell.reuseIdentifier, for: indexPath) as! ReviewContentCell
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewAddPhoto.reuseIdentifier, for: indexPath) as! ReviewAddPhoto
            
            cell.delegate = self
            cell.selectedPhotos = selectedPhotos
            cell.reviewImageCollectionView.reloadData()
            
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewGuidelines.reuseIdentifier, for: indexPath) as! ReviewGuidelines
            
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
            
            // Footer Style 지정
            footer.configureLineView(.menuDetail)
            
            return footer
        }
        return UICollectionReusableView()
    }
}

extension ReviewWriteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
                
        let group = DispatchGroup()
        var newImages: [UIImage] = []
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let selectedImage = image as? UIImage {
                    newImages.append(selectedImage)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.selectedPhotos = newImages
            self.reviewWriteCollectionView.reloadData()
        }
    }
}
