//
//  RankingInfoViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RankingInfoViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let backgroundTapGesture = UITapGestureRecognizer().then {
        $0.cancelsTouchesInView = false
    }
    
    // MARK: - Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(radius: 10)
    }
    
    private let rankingTitleLabel = UILabel().then {
        $0.setLabel("랭킹 점수 설명", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let rankingDescriptionLabel = UILabel().then {
        $0.setLabel("랭킹의 만점은 10점 만점 기준입니다.\n업데이트는 한 학기 기준입니다.", font: .pretendard_medium, size: 13, color: ._999999)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(backgroundTapGesture)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            containerView
        ].forEach(view.addSubview)
        
        [
            rankingTitleLabel,
            rankingDescriptionLabel
        ].forEach(containerView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        rankingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.centerX.equalToSuperview()
        }
        
        rankingDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(rankingTitleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
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
}
