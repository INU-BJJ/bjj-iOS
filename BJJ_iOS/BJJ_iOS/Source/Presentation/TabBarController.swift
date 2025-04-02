//
//  TabBarController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/11/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - UI Components
    
    private let homeTab = UITabBarItem().then {
        $0.title = "홈"
        $0.image = UIImage(named: "Home")
        $0.imageInsets = UIEdgeInsets(top: 4.7, left: 0, bottom: -4.7, right: 0)
    }
    
    private let rankingTab = UITabBarItem().then {
        $0.title = "랭킹"
        $0.image = UIImage(named: "Tier")
        $0.imageInsets = UIEdgeInsets(top: 4.7, left: 0, bottom: -4.7, right: 0)
    }
    
    private let reviewTab = UITabBarItem().then {
        $0.title = "리뷰"
        $0.image = UIImage(named: "Review")
        $0.imageInsets = UIEdgeInsets(top: 4.7, left: 0, bottom: -4.7, right: 0)
    }
    
    private let myPageTab = UITabBarItem().then {
        $0.title = "마이페이지"
        $0.image = UIImage(named: "MyPage")
        $0.imageInsets = UIEdgeInsets(top: 4.7, left: 0, bottom: -4.7, right: 0)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
}

extension TabBarController {
    
    // MARK: - Configure TabBar
    
    private func configureTabBar() {
        tabBar.setTabBar()
        
        let homeVC = HomeViewController()
        let homeNavigationVC = UINavigationController(rootViewController: homeVC)
        
        let rankingVC = MenuRankingViewController()
        let rankingNavigationVC = UINavigationController(rootViewController: rankingVC)
        
        let reviewVC = MyReviewViewController()
        let reviewNavigationVC = UINavigationController(rootViewController: reviewVC)
        
        // TODO: myPageViewController로 교체
        let myPageVC = HomeViewController()
        let myPageNavigationVC = UINavigationController(rootViewController: myPageVC)
        
        viewControllers = [homeNavigationVC, rankingNavigationVC, reviewNavigationVC, myPageNavigationVC]
        
        homeNavigationVC.tabBarItem = homeTab
        rankingNavigationVC.tabBarItem = rankingTab
        reviewNavigationVC.tabBarItem = reviewTab
        myPageNavigationVC.tabBarItem = myPageTab
    }
}
