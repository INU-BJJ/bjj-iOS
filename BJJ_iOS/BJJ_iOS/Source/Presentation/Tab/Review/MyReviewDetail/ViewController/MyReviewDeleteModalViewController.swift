//
//  MyReviewDeleteModal.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/5/25.
//

import UIKit

final class MyReviewDeleteModalViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MyReviewDeleteDelegate?
    
    // MARK: - UI Components
    
    // TODO: view는 lazy var로, button은 let으로 이벤트 감지함. 차이점 공부
    private lazy var deleteModalView = UIView().then {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.5)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)))
    }
    
    private let reviewActionView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    private lazy var deleteButton = UIButton().then {
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.setTitleColor(.customColor(.warningRed), for: .normal)
        $0.contentHorizontalAlignment = .leading
        $0.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    private lazy var reportButton = UIButton().then {
        $0.setTitle("신고하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .leading
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            deleteModalView
        ].forEach(view.addSubview)
        
        [
            reviewActionView
        ].forEach(deleteModalView.addSubview)
        
        [
            deleteButton,
            reportButton
        ].forEach(reviewActionView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        deleteModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reviewActionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(605)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(76)
            $0.height.equalTo(18)
        }
        
        // TODO: deleteButton과의 간격 수정
        reportButton.snp.makeConstraints {
            $0.top.equalTo(deleteButton.snp.bottom).offset(65)
            $0.leading.trailing.equalTo(deleteButton)
            $0.height.equalTo(18)
        }
    }
    
    // MARK: - Objc Function
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDeleteButton() {
        delegate?.didTapDeleteButton()
    }
}
