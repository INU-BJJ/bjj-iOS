//
//  AlertViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/14/25.
//

import UIKit
import SnapKit
import Then

final class AlertViewController: UIViewController {

    // MARK: - Properties
    
    private var alertType: AlertType
    
    // MARK: - UI Components
    
    private let alertView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let circleIconView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var alertImageView = UIImageView().then {
        $0.image = UIImage(named: alertType.imageName)
    }
    
    private let alertMessageView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let alertMessageLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    // MARK: - LifeCycle
    
    init(alertType: AlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
        setAlertViewUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        circleIconView.layoutIfNeeded()
        circleIconView.layer.cornerRadius = circleIconView.bounds.width / 2
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)))
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            alertView
        ].forEach(view.addSubview)
        
        [
            alertMessageView,
            circleIconView,
            alertMessageLabel
        ].forEach(alertView.addSubview)
        
        [
            alertImageView
        ].forEach(circleIconView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        alertView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(351)
            $0.horizontalEdges.equalToSuperview().inset(62)
            $0.bottom.equalToSuperview().inset(369)
        }
        
        circleIconView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(87)
            $0.bottom.equalToSuperview().inset(37)
        }
        
        alertImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(13)
        }
        
        alertMessageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(58)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        alertMessageLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertMessageView)
            $0.centerY.equalTo(alertMessageView)
        }
    }
    
    private func setAlertViewUI() {
        alertMessageLabel.text = alertType.title
    }
    
    // MARK: - objc Functions
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}
