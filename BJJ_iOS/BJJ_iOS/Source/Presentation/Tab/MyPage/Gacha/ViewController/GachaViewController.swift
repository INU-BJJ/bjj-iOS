//
//  GachaViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class GachaViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let backgroundTapGesture = UITapGestureRecognizer().then {
        $0.cancelsTouchesInView = false
    }
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(radius: 10)
    }
    
    private let testGachaLabel = UILabel().then {
        $0.setLabelUI("캐릭터 뽑기", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private lazy var testGachaButton = UIButton().then {
        $0.setTitle("50", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .yellow
        $0.addTarget(self, action: #selector(didTapGachaButton), for: .touchUpInside)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(backgroundTapGesture)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        view.addSubview(containerView)
        
        [
            testGachaLabel,
            testGachaButton
        ].forEach(containerView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        testGachaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(22)
        }
        
        testGachaButton.snp.makeConstraints {
            $0.top.equalTo(testGachaLabel.snp.bottom).offset(71)
            $0.horizontalEdges.equalToSuperview().inset(116)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        // 배경 탭
        backgroundTapGesture.rx.event
            .bind(with: self) { owner, gesture in
                let location = gesture.location(in: owner.view)
                if !owner.containerView.frame.contains(location) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func didTapGachaButton() {
        DispatchQueue.main.async {
            self.presentGachaResultViewController()
        }
    }
}
