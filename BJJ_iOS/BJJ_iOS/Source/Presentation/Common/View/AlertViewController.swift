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
    
    private lazy var testBackButton = UIButton().then {
        $0.setImage(UIImage(named: "BlackBackButton"), for: .normal)
        $0.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    private let testAlertTitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 18, color: .black)
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
        setAlertTitle()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testBackButton,
            testAlertTitleLabel
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testBackButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        testAlertTitleLabel.snp.makeConstraints {
            $0.top.equalTo(testBackButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setAlertTitle() {
        testAlertTitleLabel.text = alertType.title
    }
    
    // MARK: - objc Functions
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}
