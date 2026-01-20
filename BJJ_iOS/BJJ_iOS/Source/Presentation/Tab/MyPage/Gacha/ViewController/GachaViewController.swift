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
    private let itemType: ItemType
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(radius: 10)
    }
    
    private let gachaTitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let gachaGuideLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_medium, size: 13, color: ._999999)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let gachaButton = UIButton().then {
        $0.setCornerRadius(radius: 5)
    }
    
    // MARK: - Init
    
    init(itemType: ItemType) {
        self.itemType = itemType
        super.init(nibName: nil, bundle: nil)
        configureUI(itemType: itemType)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // 뽑기 버튼 탭
        gachaButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentGachaResultViewController(itemType: owner.itemType)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure UI
    
    private func configureUI(itemType: ItemType) {
        let firstGuideMessage = itemType == .character ? "캐릭터를" : "배경을"
        let secondGuideMessage = itemType == .character ? "캐릭터는" : "배경은"
        
        gachaTitleLabel.text = itemType == .character ? "캐릭터 뽑기" : "배경 뽑기"
        gachaGuideLabel.text = "뽑기를 해서 랜덤으로 \(firstGuideMessage) 얻어요.\n뽑은 \(secondGuideMessage) 7일의 유효기간이 있어요."
        gachaButton.setButtonWithIcon(
            title: itemType == .character ? "50" : "100",
            font: .pretendard_medium,
            size: 18,
            textColor: .black,
            icon: .point,
            iconPadding: 7,
            backgroundColor: .FFEB_62
        )
    }
}
