//
//  BaseViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/12/26.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    // MARK: - DisposeBag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setHierarchy()
        setConstraints()
        bind()
    }
    
    // MARK: - Set UI
    
    func setUI() { }
    
    // MARK: - Set Hierarchy
    
    func setHierarchy() { }
    
    // MARK: - Set Constraints
    
    func setConstraints() { }
    
    // MARK: - Bind
    
    func bind() { }
}
