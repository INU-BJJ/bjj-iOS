//
//  MyReviewDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

protocol MyReviewDeleteDelegate: AnyObject {
    func didTapDeleteButton()
}

final class MyReviewDetailViewController: UIViewController {
    
    // MARK: - ViewModel
    
    private let viewModel: MyReviewDetailViewModel
    
    // MARK: - Properties
    
    private var myReviewData: MyReviewDetailSection?
    private let reviewID: Int
    
    // MARK: - UI Components
    
    private lazy var myReviewStackView = MyReviewDetailView().then {
        $0.delegate = self
    }
    
    // MARK: - LifeCycle
    
    init(viewModel: MyReviewDetailViewModel, reviewID: Int) {
        self.viewModel = viewModel
        self.reviewID = reviewID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMyReviewDetail(reviewID: reviewID)
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackMoreNaviBar("리뷰 상세")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            myReviewStackView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        myReviewStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Configure MyReviewDetailVC
    
    private func configureMyReviewDetailVC() {
        if let myReviewData = myReviewData {
            myReviewStackView.configureMyDatailReview(with: myReviewData)
        }
    }
    
    // MARK: - Delete API Functions
    
    private func deleteMyReview(reviewID: Int) {
        MyReviewDetailAPI.deleteMyReview(reviewID: reviewID) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated: false)
                    self.presentMyReviewViewController()
                }
                
            case .failure(let error):
                print("<< [MyReviewDetailVC] \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMyReviewDetail(reviewID: Int) {
        MyReviewDetailAPI.fetchMyReviewDetail(reviewID: reviewID) { result in
            switch result {
            case .success(let myDetailReview):
                self.myReviewData = MyReviewDetailSection(
                                        reviewID: myDetailReview.reviewID,
                                        reviewComment: myDetailReview.reviewComment,
                                        reviewRating: myDetailReview.reviewRating,
                                        reviewImages: myDetailReview.reviewImages,
                                        reviewLikedCount: myDetailReview.reviewLikedCount,
                                        reviewCreatedDate: myDetailReview.reviewCreatedDate,
                                        menuPairID: myDetailReview.menuPairID,
                                        mainMenuID: myDetailReview.mainMenuID,
                                        mainMenuName: myDetailReview.mainMenuName,
                                        subMenuID: myDetailReview.subMenuID,
                                        subMenuName: myDetailReview.subMenuName,
                                        memberID: myDetailReview.memberID,
                                        memberNickname: myDetailReview.memberNickname,
                                        memberImage: myDetailReview.memberImage,
                                        isOwned: myDetailReview.isOwned,
                                        isLiked: myDetailReview.isLiked
                                    )
                self.configureMyReviewDetailVC()
                
            case .failure(let error):
                print("[MyReviewDetailVC] Fetch Error: \(error.localizedDescription)")
            }
        }
    }
}

extension MyReviewDetailViewController: MyReviewDeleteDelegate {
    func didTapDeleteButton() {
        if let myReviewID = myReviewData?.reviewID {
            deleteMyReview(reviewID: myReviewID)
        }
    }
}

extension MyReviewDetailViewController: MyReviewDetailDelegate {
    func didTapReviewImage(with reviewImages: [String]) {
        presentMyReviewImageDetailViewController(with: reviewImages)
    }
}
