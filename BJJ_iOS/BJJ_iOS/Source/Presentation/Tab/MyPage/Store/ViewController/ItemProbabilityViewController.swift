//
//  ItemProbabilityViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/19/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ItemProbabilityViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let backgroundTapGesture = UITapGestureRecognizer().then {
        $0.cancelsTouchesInView = false
    }
    
    // MARK: - Components
    
    private let itemProbabilityImage = UIImageView().then {
        $0.setImage(.itemProbability)
        $0.setCornerRadius(radius: 10)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(backgroundTapGesture)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        view.addSubview(itemProbabilityImage)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        itemProbabilityImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(85)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        // 배경 탭
        backgroundTapGesture.rx.event
            .bind(with: self) { owner, gesture in
                let location = gesture.location(in: owner.view)
                if !owner.itemProbabilityImage.frame.contains(location) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
