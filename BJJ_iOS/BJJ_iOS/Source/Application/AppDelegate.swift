//
//  AppDelegate.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import SDWebImageSVGCoder
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase 초기화
        FirebaseApp.configure()
        
        // FCM delegate 설정
        Messaging.messaging().delegate = self
        
        // 푸시 알림 권한 요청
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        // 이전에 권한을 요청했는지 확인
        let didRequestBefore = UserDefaultsManager.shared.readBool(.didRequestNotificationPermission)

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { granted, _ in
            // 권한 요청 완료 후 상태 저장
            UserDefaultsManager.shared.save(value: true, key: .didRequestNotificationPermission)
            
            // 권한 허용 시에만 APNs 등록
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if !didRequestBefore {
                // 처음 권한 요청 시 거부한 경우에만 alert 표시
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = windowScene.windows.first?.rootViewController {
                        rootVC.showAlert(title: "알림 수신 거부 처리 결과", message: "푸시 알림 수신을 원하시면 [설정] > [앱] > [밥점줘]에서 알림을 허용해주세요.")
                    }
                }
            }
        }
        
        // SDWebImageSVGCoder 설정
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        
        // IQKeyboardManager 설정
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistance = 20
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - APNs Token

    // APNs 토큰 등록 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // FCM에 APNs 토큰 전달
        Messaging.messaging().apnsToken = deviceToken
    }

    // APNs 토큰 등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground에서 푸시 알림 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Foreground에서도 알림 표시
        completionHandler([.banner, .badge, .sound])
    }

    // 푸시 알림 탭
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: 딥링크 처리 등 필요한 액션 추가
        completionHandler()
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {

    // FCM 토큰 갱신
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        
        // 서버에 FCM 토큰을 전송 로직 추가
    }
}
