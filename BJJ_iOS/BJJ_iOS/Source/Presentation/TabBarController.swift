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
    }
    
    private let tierTab = UITabBarItem().then {
        $0.title = "티어표"
        $0.image = UIImage(named: "Tier")
    }
    
    private let reviewTab = UITabBarItem().then {
        $0.title = "리뷰"
        $0.image = UIImage(named: "Review")
    }
    
    private let myPageTab = UITabBarItem().then {
        $0.title = "마이페이지"
        $0.image = UIImage(named: "MyPage")
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
        
        // TODO: tierViewController로 교체
        let tierVC = HomeViewController()
        let tierNavigationVC = UINavigationController(rootViewController: tierVC)
        
        let reviewVC = MyReviewViewController()
        let reviewNavigationVC = UINavigationController(rootViewController: reviewVC)
        
        // TODO: myPageViewController로 교체
        let myPageVC = HomeViewController()
        let myPageNavigationVC = UINavigationController(rootViewController: myPageVC)
        
        viewControllers = [homeNavigationVC, tierNavigationVC, reviewNavigationVC, myPageNavigationVC]
        
        homeNavigationVC.tabBarItem = homeTab
        tierNavigationVC.tabBarItem = tierTab
        reviewNavigationVC.tabBarItem = reviewTab
        myPageNavigationVC.tabBarItem = myPageTab
    }
}
