//
//  MyReviewDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
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
        setBackMoreNaviBar("리뷰 상세")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
}
