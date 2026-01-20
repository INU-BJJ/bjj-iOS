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
    
    private let gachaTitleLabel = UILabel().then {
        $0.setLabelUI("캐릭터 뽑기", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let gachaGuideLabel = UILabel().then {
        $0.setLabel(
            "뽑기를 해서 랜덤으로 캐릭터를 얻어요.\n뽑은 캐릭터는 7일의 유효기간이 있어요.",
            font: .pretendard_medium,
            size: 13,
            color: ._999999
        )
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var gachaButton = UIButton().then {
        $0.setButtonWithIcon(
            title: "100",
            font: .pretendard_medium,
            size: 18,
            textColor: .black,
            icon: .point,
            iconPadding: 7,
            backgroundColor: .FFEB_62
        )
        $0.setCornerRadius(radius: 5)
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
            gachaTitleLabel,
            gachaGuideLabel,
            gachaButton
        ].forEach(containerView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        gachaTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(22)
        }
        
        gachaGuideLabel.snp.makeConstraints {
            $0.top.equalTo(gachaTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        gachaButton.snp.makeConstraints {
            $0.top.equalTo(gachaTitleLabel.snp.bottom).offset(71)
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
            // TODO: 상점 페이지에서 캐릭터, 배경 탭의 상태를 전달받기.
            self.presentGachaResultViewController(itemType: .character)
        }
    }
}
