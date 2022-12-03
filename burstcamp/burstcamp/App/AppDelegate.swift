//
//  AppDelegate.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/15.
//

import UIKit

import Firebase
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        configurePushNotification(application)
        configureMessaging()
        return true
    }
}

// TODO: HomeViewController로 옮기기
// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func configurePushNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { isPushOn, _ in
            // TODO: update isPushOn
            print("알림 허용했나요? ", isPushOn)
        }

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
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }

    // token refresh monitoring
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        // TODO: change userUUID
        if let fcmToken = fcmToken {
            FirebaseFCMToken.save(fcmToken: fcmToken, to: "zP9Kqm1JwzXLoPfsrrWSOA4u7P33")
        }
    }
}

// MARK: - save user in keychain

extension AppDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        KeyChainManager.deleteUser()
        KeyChainManager.save(user: UserManager.shared.user)
    }
}
