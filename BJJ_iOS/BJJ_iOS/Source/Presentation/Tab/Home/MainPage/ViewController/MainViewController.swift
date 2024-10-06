//
//  MainViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import SnapKit
import Then

final class MainViewController: UIViewController {

    // MARK: Properties
    
    // MARK: UI Components
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: Bind
    
    func bind() {
        
        // MARK: Action
        
        // MARK: State
        
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: Set AddViews
    
    private func setAddView() {
        [
         
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
       
    }
}

