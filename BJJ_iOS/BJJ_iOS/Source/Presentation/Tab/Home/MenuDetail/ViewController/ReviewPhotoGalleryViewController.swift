//
//  ReviewPhotoGalleryViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/9/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ReviewPhotoGalleryViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
        setBackNaviBar("리뷰 사진 모아보기")
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
