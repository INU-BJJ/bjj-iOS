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
    
    /// 마이페이지 네비바
    func setMyPageNaviBar() {
        let titleLabel = UILabel().then {
            $0.setLabelUI("마이페이지", font: .pretendard_bold, size: 18, color: .black)
        }
        let settingButton = self.navigationItem.makeImageButtonItem(self, action: #selector(settingTapped), imageName: "gear")
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = settingButton
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
    }
    
    /// 상점 네비바
    func setStoreNaviBar(point: Int) {
        let backButton = UIButton().then {
            $0.setImage(UIImage(named: ImageAsset.BlackBackButton.name), for: .normal)
            $0.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        }
        let infoButton = UIButton().then {
            $0.setImage(UIImage(named: ImageAsset.orangeInfo.name), for: .normal)
            $0.addTarget(self, action: #selector(itemInfoTapped), for: .touchUpInside)
        }
        let pointView = PointView().then {
            $0.configurePointView(point: point)
        }
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: backButton),
            UIBarButtonItem(customView: infoButton)
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointView)
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
        if let tabBarController = self.tabBarController,
           let viewControllers = tabBarController.viewControllers {
            for vc in viewControllers {
                if let navigationVC = vc as? UINavigationController,
                   navigationVC.viewControllers.first is MyReviewViewController {
                    tabBarController.selectedViewController = navigationVC
                    navigationVC.popToRootViewController(animated: true)
                    break
                }
            }
        }
    }
    
    /// CafeteriaMyReviewVC로 push
    func presentCafeteriaMyReviewViewController(title: String) {
        let cafeteriaMyReviewVC = CafeteriaMyReviewViewController(cafeteriaName: title)
        cafeteriaMyReviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cafeteriaMyReviewVC, animated: true)
    }
    
    /// MyReviewDetailVC로 push
    func presentMyReviewDetailViewController(reviewID: Int) {
        let myReviewDetailVC = MyReviewDetailViewController(reviewID: reviewID)
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
    
    /// MyPageVC로 push
    func presentMyPageViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// StoreVC로 push
    func presentStoreViewController() {
        let storeVC = StoreViewController()
        storeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(storeVC, animated: true)
    }
    
    /// GachaVC로 push
    func presentGachaViewController(itemType: ItemType) {
        let gachaVC = GachaViewController(itemType: itemType)
        
        gachaVC.modalPresentationStyle = .overFullScreen
        present(gachaVC, animated: true)
    }
    
    /// GachaResultVC로 push
    func presentGachaResultViewController(itemType: ItemType) {
        let gachaResultViewModel = GachaResultViewModel(itemType: itemType)
        let gachaResultVC = GachaResultViewController(viewModel: gachaResultViewModel)
        
        gachaResultVC.modalPresentationStyle = .fullScreen
        present(gachaResultVC, animated: true)
    }
    
    /// SettingVC로 push
    func presentSettingViewController() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    /// NicknameEditVC로 push
    func presentNicknameEditViewController() {
        let nicknameEditVC = NicknameEditViewController()
        nicknameEditVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nicknameEditVC, animated: true)
    }
    
    /// LikedMenuVC로 push
    func presentLikedMenuViewController() {
        let likedMenuVC = LikedMenuViewController()
        likedMenuVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(likedMenuVC, animated: true)
    }
    
    /// ReportReviewVC로 push
    func presentReportReviewViewController(reviewID: Int) {
        let reportReviewVC = ReportReviewViewController(reviewID: reviewID)
        reportReviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reportReviewVC, animated: true)
    }
    
    /// ServiceVC로 push
    func pushServicePolicyVC() {
        let servicePolicyVC = ServicePolicyViewController()
        servicePolicyVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(servicePolicyVC, animated: true)
    }
    
    // MARK: - Modal Present
    
    /// 랭킹 인포 모달 present
    func presentRankingInfoViewController() {
        let rankingInfoVC = RankingInfoViewController()
        rankingInfoVC.modalPresentationStyle = .overFullScreen
        present(rankingInfoVC, animated: true)
    }
    
    // MARK: - Alert
    
    /// AlertVC로 present
    func presentAlertViewController(
        alertType: AlertType,
        title: String,
        duration: TimeInterval = 0.5,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = AlertViewController(alertType: alertType, text: title)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle   = .crossDissolve
        
        present(alertVC, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alertVC.dismiss(animated: true, completion: completion)
            }
        }
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
    
    /// 설정 버튼 탭
    @objc func settingTapped() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    /// 아이템 확률 modal
    @objc func itemInfoTapped() {
        let itemProbabilityVC = ItemProbabilityViewController()
        itemProbabilityVC.modalPresentationStyle = .overFullScreen
        present(itemProbabilityVC, animated: true)
    }
}
