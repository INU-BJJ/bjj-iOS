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
    
    private let deleteButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    private let deleteLabel = UILabel().then {
        $0.setLabelUI("삭제하기", font: .pretendard_medium, size: 15, color: .warningRed)
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
            deleteButton,
            deleteLabel
        ].forEach(deleteModalView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        deleteModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(605)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        deleteLabel.snp.makeConstraints {
            $0.top.equalTo(deleteButton.snp.top).offset(35)
            $0.leading.equalTo(deleteButton.snp.leading).offset(20)
        }
    }
    
    // MARK: - Objc Function
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDeleteButton() {
        delegate?.didTapDeleteButton()
        
        // TODO: MyReviewVC로 이동 및 MyReviewVC의 tableView reloadData
    }
}
