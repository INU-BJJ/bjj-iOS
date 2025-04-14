//
//  GachaViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import UIKit
import SnapKit
import Then

final class GachaViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let testGachaView = UIView().then {
        $0.backgroundColor = .white
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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)))
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testGachaView
        ].forEach(view.addSubview)
        
        [
            testGachaLabel,
            testGachaButton
        ].forEach(testGachaView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testGachaView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(170)
        }
        
        testGachaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(22)
        }
        
        testGachaButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.horizontalEdges.equalToSuperview().inset(116)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func dismissModal() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func didTapGachaButton() {
        DispatchQueue.main.async {
            self.presentGachaResultViewController()
        }
    }
}
