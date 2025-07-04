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

// MARK: - Delegate Pattern

protocol ReviewCategorySelectDelegate: AnyObject {
    func didSelectCafeteria(_ cafeteriaName: String, sender: ReviewCategorySelect)
    func didSelectMenu(_ menuPairID: Int)
}

protocol ReviewRatingDelegate: AnyObject {
    func didSelectRating(_ rating: Int)
}

final class ReviewWriteViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedPhotos: [UIImage] = []
    private let maxPhotoCount = 4
    private var selectedMenuPairID: Int?
    private var selectedRating: Int = 5
    
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
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var submitReviewButton = UIButton().makeConfirmButton(type: .submitReview).then {
        $0.addTarget(self, action: #selector(didTapSubmitReview), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        dismissKeyboard()
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
            $0.bottom.equalToSuperview().inset(140)
        }
        
        submitReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(55)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        return ReviewWriteCollectionViewLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(83))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 36, trailing: 0)
        
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
    
    // MARK: - Fetch API
    
    private func fetchMenuList(cafeteriaName: String, completion: @escaping ([ReviewWriteSection]) -> Void) {
        ReviewWriteAPI.fetchMenuList(cafeteriaName: cafeteriaName) { [weak self] result in
            switch result {
            case .success(let reviewMenuInfos):
                let menuData = reviewMenuInfos.map { menu in
                    ReviewWriteSection(
                        menuPairID: menu.menuPairID,
                        mainMenuName: menu.mainMenuName
                    )
                }
                completion(menuData)
                
            case .failure(let error):
                print("Error fetching menu data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Post API Function
    
    @objc private func didTapSubmitReview() {
        guard let menuPairID = selectedMenuPairID else { return }
        let indexPath = IndexPath(item: 0, section: 2)
        
        if let cell = reviewWriteCollectionView.cellForItem(at: indexPath) as? ReviewContentCell {
            let reviewText = cell.getReviewText()
            let params: [String: Any] = [
                "comment": reviewText,
                "rating": selectedRating,
                "menuPairId": menuPairID
            ]

            ReviewWriteAPI.postReview(params: params, images: selectedPhotos) { result in
                switch result {
                case .success:
                    self.presentMyReviewViewController()
                case .failure(let error):
                    print("<< [ReviewWriteVC] 리뷰 등록 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Validate Review Inputs
    
    private var isValidReviewSubmit: Bool {
        let isReviewTextEmpty: Bool
        
        if let indexPath = IndexPath(item: 0, section: 2) as IndexPath?,
           let cell = reviewWriteCollectionView.cellForItem(at: indexPath) as? ReviewContentCell {
            isReviewTextEmpty = cell.getReviewText().isEmpty
        } else {
            isReviewTextEmpty = true
        }
        
        return selectedMenuPairID != nil && !isReviewTextEmpty && selectedRating > 0
    }
    
    // MARK: - Set SubmitButton Color
    
    private func setSubmitButtonColor() {
        submitReviewButton.backgroundColor = isValidReviewSubmit
            ? UIColor.customColor(.mainColor)
            : UIColor.customColor(.midGray)
    }
}

// MARK: - UICollectionView Extension

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
            cell.delegate = self
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewRatingCell.reuseIdentifier, for: indexPath) as! ReviewRatingCell
            cell.delegate = self
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewContentCell.reuseIdentifier, for: indexPath) as! ReviewContentCell
            cell.delegate = self
            
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

// MARK: - PHPickerViewController Extension

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
            self.selectedPhotos.append(contentsOf: newImages)
            UIView.performWithoutAnimation {
                self.reviewWriteCollectionView.reloadItems(at: [IndexPath(item: 0, section: 3)])
            }
        }
    }
}

// MARK: - didTapPhoto

extension ReviewWriteViewController: ReviewPhotoDelegate {
    func didTapAddPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = maxPhotoCount - selectedPhotos.count
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func didTapDeselectPhoto(at indexPath: IndexPath) {
        guard indexPath.item < selectedPhotos.count else { return }
        
        selectedPhotos.remove(at: indexPath.item)
        UIView.performWithoutAnimation {
            reviewWriteCollectionView.reloadItems(at: [IndexPath(item: 0, section: 3)])
        }
    }
}

// MARK: - didTapCategorySelect

extension ReviewWriteViewController: ReviewCategorySelectDelegate {
    func didSelectCafeteria(_ cafeteriaName: String, sender: ReviewCategorySelect) {
        fetchMenuList(cafeteriaName: cafeteriaName) { [weak self] menuData in
            // UI 업데이트를 수행하기 때문에 메인 스레드에서 실행
            DispatchQueue.main.async {
                sender.updateMenuData(menuData)
            }
        }
    }
    
    func didSelectMenu(_ menuPairID: Int) {
        selectedMenuPairID = menuPairID
        setSubmitButtonColor()
    }
}

// MARK: - didTapReviewRating

extension ReviewWriteViewController: ReviewRatingDelegate {
    func didSelectRating(_ rating: Int) {
        selectedRating = rating
        setSubmitButtonColor()
    }
}

// MARK: - didChangeReviewText

extension ReviewWriteViewController: ReviewContentDelegate {
    func didChangeReviewText(_ text: String) {
        setSubmitButtonColor()
    }
}

extension ReviewWriteViewController {
    
    // MARK: Dismiss Keyboard
    // TODO: [UIKeyboardTaskQueue lockWhenReadyForMainThread] timeout waiting for task on queue 해결하기
    // TODO: 키보드에 textView가 가려지는 문제 해결하기
    
    private func dismissKeyboard() {
        self.view.gestureRecognizers?.forEach { self.view.removeGestureRecognizer($0) }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addDismissKeyboardGesture))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func addDismissKeyboardGesture() {
        self.view.endEditing(true)
    }
}
