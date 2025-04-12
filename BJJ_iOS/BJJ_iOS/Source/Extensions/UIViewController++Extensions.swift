//
//  UIViewController++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/2/24.
//

import UIKit
import SnapKit
import Then

extension UIViewController {
    
    // MARK: - Navi Bar
    
    /// 투명 배경 + 흰색 Back 버튼 + X 버튼 Navigation Bar
    func setClearWhiteBackNaviBar() {
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "BackButton")
        let xButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "XButton")
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = xButton
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .clear
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundEffect = nil
        
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
    }
    
    /// 투명 배경 + 흰색 Back 버튼 + X 버튼 Navigation Bar
    func setClearWhiteBackTitleNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.setLabelUI(title, font: .pretendard_medium, size: 15, color: .white)
        }
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "BackButton")
        let xButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "XButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = xButton
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .clear
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundEffect = nil
        
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
    }
    
    /// Back 버튼이 없는 Navigation Bar
    func setNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.setLabelUI(title, font: .pretendard_bold, size: 18, color: .black)
        }
        
        self.navigationItem.titleView = titleLabel
    }
    
    /// 흰 배경 + 검정 Back 버튼 Navigation Bar
    func setBackNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.setLabelUI(title, font: .pretendard_bold, size: 18, color: .black)
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "BlackBackButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = backButton
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .white
        
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
    }
    
    /// 흰 배경 + 검정 Back 버튼 + More 버튼 Navigation Bar
    func setBackMoreNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.setLabelUI(title, font: .pretendard_bold, size: 18, color: .black)
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "BlackBackButton")
        let moreButton = self.navigationItem.makeImageButtonItem(self, action: #selector(showMoreOptions), imageName: "VerticalMoreButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = moreButton
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .white
        
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
    }
    
    // MARK: - Push ViewController
    
    /// MenuDetailVC로 push
    func presentMenuDetailViewController() {
        let menuDetailVC = MenuDetailViewController()
        menuDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(menuDetailVC, animated: true)
    }
    
    /// MyReviewVC로 push
    func presentMyReviewViewController() {
        guard let tabBarController = self.tabBarController else { return }
            
        tabBarController.selectedIndex = 2
        
        if let navigationController = tabBarController.selectedViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    /// CafeteriaMyReviewVC로 push
    func presentCafeteriaMyReviewViewController(title: String) {
        let cafeteriaMyReviewVC = CafeteriaMyReviewViewController(cafeteriaName: title)
        cafeteriaMyReviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cafeteriaMyReviewVC, animated: true)
    }
    
    /// MyReviewDetailVC로 push
    func presentMyReviewDetailViewController() {
        let myReviewDetailVC = MyReviewDetailViewController()
        myReviewDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myReviewDetailVC, animated: true)
    }
    
    /// MyReviewImageDetailVC로 push
    func presentMyReviewImageDetailViewController(with reviewImages: [String]) {
        let myReviewImageDetailVC = MyReviewImageDetailPageViewController(with: reviewImages)
        myReviewImageDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myReviewImageDetailVC, animated: true)
    }
    
    /// ReviewWriteVC로 push
//    func presentReviewWriteViewController() {
//        let reviewWriteVC = ReviewWriteViewController()
//        reviewWriteVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(reviewWriteVC, animated: true)
//    }
    
    /// StoreVC로 push
    func presentStoreViewController(point: Int) {
        let storeVC = StoreViewController(point: point)
        storeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(storeVC, animated: true)
    }
    
    // MARK: - objc Function
    
    /// popVC
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 더보기 버튼
    @objc func showMoreOptions() {
        let modalVC = MyReviewDeleteModalViewController()
        guard let delegateVC = self as? MyReviewDeleteDelegate else { return }

        modalVC.delegate = delegateVC
        modalVC.modalPresentationStyle = .overCurrentContext
        
        present(modalVC, animated: true)
    }
}
