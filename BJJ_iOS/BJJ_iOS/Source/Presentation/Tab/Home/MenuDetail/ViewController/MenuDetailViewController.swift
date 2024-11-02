//
//  MenuDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class MenuDetailViewController: UIViewController {
    
    // MARK: - Properties
  
    // MARK: - UI Components
    
    private let menuDefaultImageView = UIImageView().then {
        $0.image = UIImage(named: "MenuImage2")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: - Action
        
        // MARK: - State
        
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
         menuDefaultImageView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuDefaultImageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(272)
        }
    }
    
    // MARK: - Create Layout
   
}
