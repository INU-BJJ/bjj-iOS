//
//  StoreViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/12/25.
//

import UIKit
import SnapKit
import Then

final class StoreViewController: UIViewController {
    
    // MARK: - Properties
    
    private var point: Int
    
    // MARK: - UI Components
    
    private let testPointLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private lazy var testGachaMachine = UIImageView().then {
        $0.image = UIImage(named: "GachaMachine")
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGachaMachine)))
    }
    
    // TODO: 다른 부분 터치하면 다시 숨기기
    private let testGachaView = UIView().then {
        $0.isHidden = true
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let testGachaLabel = UILabel().then {
        $0.setLabelUI("캐릭터 뽑기", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private lazy var testGachaButton = UIButton().then {
        $0.setTitle("50", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .yellow
    }
    
    // MARK: - LifeCycle
    
    init(point: Int) {
        self.point = point
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
        setUI()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testPointLabel,
            testGachaMachine,
            testGachaView
        ].forEach(view.addSubview)
        
        [
            testGachaLabel,
            testGachaButton
        ].forEach(testGachaView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testPointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        testGachaMachine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        testGachaView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(170)
        }
        
        testGachaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        testGachaButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.horizontalEdges.equalToSuperview().inset(116)
            $0.height.equalTo(40)
        }
    }
    
    private func setUI() {
        DispatchQueue.main.async {
            // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
            self.testPointLabel.text = "\(self.point) P"
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapGachaMachine() {
        DispatchQueue.main.async {
            self.testGachaView.isHidden = false
        }
    }
}

