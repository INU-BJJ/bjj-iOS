//
//  AlertViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/14/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AlertViewController: BaseViewController {

    // MARK: - Properties
    
    private var alertType: AlertType
    private let text: String
    private let backgroundTapGesture = UITapGestureRecognizer().then {
        $0.cancelsTouchesInView = false
    }
    
    // MARK: - Components
    
    private let circleIconView = UIView().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(radius: 79 / 2)
    }
    
    private lazy var alertImageView = UIImageView().then {
        $0.image = UIImage(named: alertType.imageName)
        $0.contentMode = .scaleAspectFit
    }
    
    private let alertMessageView = UIView().then {
        $0.setCornerRadius(radius: 10)
        $0.backgroundColor = .white
    }
    
    private let alertMessageLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 15, color: .black)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - LifeCycle
    
    init(alertType: AlertType, text: String) {
        self.alertType = alertType
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addGestureRecognizer(backgroundTapGesture)
        alertMessageLabel.text = text
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            circleIconView,
            alertMessageView,
            alertImageView
        ].forEach(view.addSubview)
        
        alertMessageView.addSubview(alertMessageLabel)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        circleIconView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(240)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(79)
        }
        
        alertImageView.snp.makeConstraints {
            $0.top.equalTo(circleIconView).offset(11)
            $0.horizontalEdges.equalTo(circleIconView).inset(12)
            $0.bottom.equalTo(circleIconView).inset(13)
        }
        
        alertMessageView.snp.makeConstraints {
            $0.top.equalTo(circleIconView).offset(46)
            $0.horizontalEdges.equalToSuperview().inset(56)
            $0.centerX.equalToSuperview()
        }
        
        alertMessageLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(23.5)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        // 배경 탭
        backgroundTapGesture.rx.event
            .bind(with: self) { owner, gesture in
                let location = gesture.location(in: owner.view)
                let circleIconFrame = owner.circleIconView.frame
                let alertMessageFrame = owner.alertMessageLabel.frame
                
                if !circleIconFrame.contains(location) && !alertMessageFrame.contains(location) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
