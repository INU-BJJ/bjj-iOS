//
//  MyReviewDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MyReviewDetailViewController: BaseViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMyReviewDetail(reviewID: reviewID)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackMoreNaviBar("리뷰 상세") { [weak self] in
            guard let self = self else { return }
            let modalVC = MyReviewMenuModalViewController(isOwned: self.viewModel.isOwned, reviewID: self.reviewID)
            modalVC.modalPresentationStyle = .overCurrentContext

            // 삭제/신고 완료 이벤트 구독
            modalVC.actionCompletedRelay
                .bind(with: self, onNext: { owner, result in
                    owner.handleActionCompleted(result)
                })
                .disposed(by: self.disposeBag)

            self.present(modalVC, animated: true)
        }
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            myReviewStackView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        myReviewStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = MyReviewDetailViewModel.Input(
            reviewLikeButtonTapped: myReviewStackView.reviewLikeButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 본인 리뷰일 때 좋아요 버튼 탭 시 알림 표시
        output.showOwnReviewAlert
            .drive(with: self) { owner, _ in
                owner.presentAlertViewController(
                    alertType: .failure,
                    title: "자신의 리뷰에는 좋아요를 누를 수 없습니다."
                )
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure MyReviewDetailVC
    
    private func configureMyReviewDetailVC() {
        if let myReviewData = myReviewData {
            myReviewStackView.configureMyDatailReview(with: myReviewData)
        }
    }
    
    // MARK: - Handle Action Completed
    
    private func handleActionCompleted(_ result: ReviewActionResult) {
        switch result {
        case .deleteSuccess:
            // TODO: 삭제 성공 토스트 메시지 표시

            // MenuDetailVC로 이동 (현재 네비게이션 스택에서 pop)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMyReviewDetail(reviewID: Int) {
        MyReviewDetailAPI.fetchMyReviewDetail(reviewID: reviewID) { result in
            switch result {
            case .success(let myDetailReview):
                // ViewModel의 isOwned 업데이트 (Relay를 통해)
                self.viewModel.updateIsOwned(myDetailReview.isOwned)

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
                self.presentAlertViewController(alertType: .failure, title: error.localizedDescription)
            }
        }
    }
}

extension MyReviewDetailViewController: MyReviewDetailDelegate {
    func didTapReviewImage(with reviewImages: [String]) {
        presentMyReviewImageDetailViewController(with: reviewImages)
    }
}
