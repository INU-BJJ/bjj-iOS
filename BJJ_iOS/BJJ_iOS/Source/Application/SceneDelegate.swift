//
//  SceneDelegate.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import PretendardKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        PretendardKit.register()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        setRootViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 알림 권한 상태 확인 및 FCM 토큰 재등록
        checkNotificationStatusAndRegisterFCMToken()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    
    /// 로그인 기록에 따른 첫 뷰컨트롤러 설정
    func setRootViewController() {
        
        if KeychainManager.hasToken(type: .accessToken) {   // 토큰이 존재하는 경우: 홈 화면으로 이동
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        } else {                                            // 토큰이 없는 경우: 로그인 화면으로 이동
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navigationController
        }
    }
    
    /// 알림 권한 상태 확인 및 FCM 토큰 재등록
    private func checkNotificationStatusAndRegisterFCMToken() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            // 알림 권한이 허용되지 않은 경우 early return
            guard settings.authorizationStatus == .authorized else { return }
            
            // APNs 재등록 (권한이 허용된 상태이므로 안전)
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            // 로그인 상태 확인
            guard let accessToken = KeychainManager.read(key: .accessToken), !accessToken.isEmpty else { return }
            
            // FCM 토큰이 있는 경우 서버에 등록 시도
            guard let fcmToken = UserDefaultsManager.shared.readString(.fcmToken) else { return }
            
            // 마지막 업로드 날짜 확인 (24시간마다 한 번씩만 업로드)
            let lastUploadDate = UserDefaultsManager.shared.readDate(.lastFCMTokenUploadDate)
            let shouldUpload: Bool
            
            if let lastDate = lastUploadDate {
                let hoursSinceLastUpload = Date().timeIntervalSince(lastDate) / 3600
                shouldUpload = hoursSinceLastUpload >= 24
            } else {
                // 업로드 기록이 없는 경우
                shouldUpload = true
            }
            
            if shouldUpload {
                FCMAPI.registerFCMToken(fcmToken: fcmToken) { result in
                    if case .success = result {
                        // 업로드 성공 시 현재 날짜 저장
                        UserDefaultsManager.shared.save(value: Date(), key: .lastFCMTokenUploadDate)
                    }
                }
            }
        }
    }
}
