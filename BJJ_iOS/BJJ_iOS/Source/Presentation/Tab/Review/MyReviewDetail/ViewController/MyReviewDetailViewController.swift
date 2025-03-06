//
//  MyReviewDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

protocol MyReviewDeleteDelegate: AnyObject {
    func didTapDeleteButton()
}

final class MyReviewDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var myReviewData: MyReviewSection?
    
    // MARK: - UI Components
    
    private let myReviewStackView = MyReviewDetailView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureMyReviewDetailVC()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackMoreNaviBar("리뷰 상세")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            myReviewStackView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        myReviewStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Bind Data
    
    func bindMyReviewData(myReview: MyReviewSection) {
        myReviewData = myReview
    }
    
    // MARK: - Configure MyReviewDetailVC
    
    private func configureMyReviewDetailVC() {
        if let myReviewData = myReviewData {
            myReviewStackView.configureMyDatailReview(with: myReviewData)
        }
    }
    
    // MARK: - API Function
    
    private func deleteMyReview(reviewID: Int) {
        MyReviewDetailAPI.deleteMyReview(reviewID: reviewID) { _ in }
    }
}

extension MyReviewDetailViewController: MyReviewDeleteDelegate {
    func didTapDeleteButton() {
        if let myReviewID = myReviewData?.reviewID {
            deleteMyReview(reviewID: myReviewID)
        }
    }
}
