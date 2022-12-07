//
//  AppDelegate.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/15.
//

import UIKit

import BCResource
import Firebase
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        UserManager.shared.appStart()
        // TODO: 삭제
        print("Auth.auth().currentUser?.uid 값이에오: ", Auth.auth().currentUser?.uid)
        print("키체인에 있던 유저의 UUID 값이에오: ", UserManager.shared.user.userUUID)
        configurePushNotification(application)
        configureMessaging()
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func configurePushNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }

    /// receive push noti when app is foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        // TODO: userInfo -> feedUUID
        print(userInfo)
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .Push,
                object: nil,
                userInfo: userInfo
            )
        }

        completionHandler([.banner, .badge, .sound])
    }

    /// receive push noti when app is background
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        // TODO: userInfo -> feedUUID
        print(userInfo)
        NotificationCenter.default.post(
            name: .Push,
            object: nil,
            userInfo: userInfo
        )
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    private func configureMessaging() {
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let token = token {
                // TODO: 삭제
                print("현재 UserManager에 있는 userUUID", UserManager.shared.user.userUUID)
                print("의 토큰 값이에오: ", token)
                UserDefaultsManager.save(fcmToken: token)
            }
        }
    }

    // token refresh monitoring
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        if let fcmToken = fcmToken, !UserManager.shared.user.userUUID.isEmpty {
            if UserManager.shared.user.userUUID.isEmpty {
                UserDefaultsManager.save(fcmToken: fcmToken)
            } else {
                FirebaseFCMToken.save(fcmToken: fcmToken, to: UserManager.shared.user.userUUID)
            }
        }
    }
}

// MARK: - save user in keychain

extension AppDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        KeyChainManager.deleteUser()
        // TODO: 삭제
        print("앱 종료 전에 키체인에 저장될 UserManager에 있는 userUUID", UserManager.shared.user.userUUID)
        KeyChainManager.save(user: UserManager.shared.user)
    }
}
