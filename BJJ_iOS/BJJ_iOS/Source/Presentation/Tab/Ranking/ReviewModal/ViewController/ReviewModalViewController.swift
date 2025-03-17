//
//  ReviewModalViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class ReviewModalViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let reviewModalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
        $0.backgroundColor = .white
        $0.layoutMargins = UIEdgeInsets(top: 17, left: 14, bottom: 17, right: 14)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let reviewInfoView = ReviewInfoView()
    
    private let reviewTextView = UITextView().then {
        $0.setTextViewUI("떡볶이 맛있당", font: .pretendard_medium, size: 13, color: .black)
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets.zero
        $0.textContainer.lineFragmentPadding = 0
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
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            reviewModalStackView
        ].forEach(view.addSubview)
        
        [
            reviewInfoView,
            reviewTextView
        ].forEach(reviewModalStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewModalStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(132)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(108)
        }
        
        reviewInfoView.snp.makeConstraints {
            $0.height.equalTo(41)
        }
    }
}
