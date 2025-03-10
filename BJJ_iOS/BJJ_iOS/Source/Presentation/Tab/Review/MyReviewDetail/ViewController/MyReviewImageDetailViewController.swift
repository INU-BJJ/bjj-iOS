//
//  MyReviewImageDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/10/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class MyReviewImageDetailViewController: UIViewController {

    // MARK: - Properties
    
    private let reviewImage: String
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    
    // MARK: - Init
    
    init(reviewImage: String) {
        self.reviewImage = reviewImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureImage()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .black
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            imageView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure Image
    
    private func configureImage() {
        imageView.kf.setImage(with: URL(string: "\(baseURL.imageURL)\(reviewImage)"))
    }
}
