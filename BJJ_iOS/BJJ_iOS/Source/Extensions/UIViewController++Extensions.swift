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
    
    /// Back 버튼이 없는 Navigation Bar
    func setNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.setLabelUI(title, font: .pretendard_bold, size: 18, color: .black)
        }
        
        self.navigationItem.titleView = titleLabel
    }
    
    /// 흰 배경 + 검정 Back 버튼
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
    
    // MARK: - Push ViewController
    
    /// MenuDetailVC로 push
    func presentMenuDetailViewController() {
        let menuDetailVC = MenuDetailViewController()
        menuDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(menuDetailVC, animated: true)
    }
    
    /// CafeteriaMyReviewVC로 push
    func presentCafeteriaMyReviewViewController() {
        let cafeteriaMyReviewVC = CafeteriaMyReviewViewController()
        cafeteriaMyReviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cafeteriaMyReviewVC, animated: true)
    }
    
    // MARK: - objc Function
    
    /// popVC
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
