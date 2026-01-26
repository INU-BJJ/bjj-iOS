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
    private let isOwned: Bool
    
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
        $0.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureButtons()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
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
    
    private func setConstraints() {
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
    
    // MARK: - Configure Buttons
    
    private func configureButtons() {
        deleteButton.isHidden = !isOwned
        reportButton.isHidden = isOwned
    }
    
    // MARK: - Objc Function
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDeleteButton() {
        delegate?.didTapDeleteButton()
    }
    
    @objc private func didTapReportButton() {
        
    }
}
