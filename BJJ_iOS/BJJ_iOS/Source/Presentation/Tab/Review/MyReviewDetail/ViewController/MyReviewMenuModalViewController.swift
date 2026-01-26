//
//  MyReviewMenuModalViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/5/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

enum ReviewActionResult {
    case deleteSuccess
}

final class MyReviewMenuModalViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let isOwned: Bool
    
    // 삭제/신고 성공 이벤트
    let actionCompletedRelay = PublishRelay<ReviewActionResult>()
    
    // MARK: - UI Components
    
    // TODO: view는 lazy var로, button은 let으로 이벤트 감지함. 차이점 공부
    private lazy var deleteModalView = UIView().then {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.5)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)))
    }
    
    private let reviewActionView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.setTitleColor(.customColor(.warningRed), for: .normal)
        $0.contentHorizontalAlignment = .leading
    }
    
    private let reportButton = UIButton().then {
        $0.setTitle("신고하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .leading
    }
    
    // MARK: - LifeCycle
    
    init(isOwned: Bool) {
        self.isOwned = isOwned
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .clear
        deleteButton.isHidden = !isOwned
        reportButton.isHidden = isOwned
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            deleteModalView,
            reviewActionView
        ].forEach(view.addSubview)
        
        [
            deleteButton,
            reportButton
        ].forEach(reviewActionView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        deleteModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reviewActionView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reportButton.snp.makeConstraints {
            $0.edges.equalTo(deleteButton)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        // 삭제하기 버튼 탭
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(
                    title: "리뷰를 삭제할까요?",
                    message: "리뷰를 삭제하면 데이터가 삭제되고 다시 볼 수 없어요.",
                    cancelTitle: "취소",
                    confirmTitle: "삭제"
                ) { [weak self] in
                    self?.handleDeleteReview()
                }
            }
            .disposed(by: disposeBag)
        
        // 신고하기 버튼 탭
        reportButton.rx.tap
            .bind(with: self) { owner, _ in
                // TODO: 신고하기 페이지로 이동
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Objc Function
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    // MARK: - API Call Methods
    
    private func handleDeleteReview() {
        
        // TODO: API 호출 - 리뷰 삭제
        
        // TODO: API 성공 시
        dismiss(animated: true) { [weak self] in
            self?.actionCompletedRelay.accept(.deleteSuccess)
        }
        
        // TODO: API 실패 시 에러 처리
    }
}
