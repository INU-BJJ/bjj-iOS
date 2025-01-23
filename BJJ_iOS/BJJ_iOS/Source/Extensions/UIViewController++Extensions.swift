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
    
    /// MenuDetailVC로 push
    func presentMenuDetailViewController() {
        let menuDetailVC = MenuDetailViewController()
        menuDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(menuDetailVC, animated: true)
    }
    
    // MARK: - objc Function
    
    /// popVC
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
