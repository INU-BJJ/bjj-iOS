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
    
    private lazy var reviewImageScrollView = UIScrollView().then {
        $0.maximumZoomScale = 3.0
        $0.minimumZoomScale = 1.0
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
    }
    
    private let reviewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
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
        
        setViewController()
        setAddView()
        setConstraints()
        setImageView()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .black
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            reviewImageScrollView
        ].forEach(view.addSubview)
        
        [
            reviewImageView
        ].forEach(reviewImageScrollView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewImageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reviewImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(186)
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Set ImageView
    
    private func setImageView() {
        reviewImageView.kf.setImage(with: URL(string: "\(baseURL.imageURL)\(reviewImage)"))
    }
}

// MARK: - UIScrollView Delegate

extension MyReviewImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return reviewImageView
    }
}
