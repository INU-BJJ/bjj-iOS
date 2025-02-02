//
//  MyReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/2/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let floatingButton = UIButton().makeFloatingButton()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setNaviBar("리뷰 페이지")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            floatingButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(29.12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(35.12)
        }
    }
}
