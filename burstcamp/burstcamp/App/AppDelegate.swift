//
//  AppDelegate.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/15.
//

import UIKit
import UserNotifications

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
        RealmConfig.serialQueue.async {
            FeedRealmDataSource.shared.configure()
        }
        UserManager.shared.appStart()
        print("Auth.auth().currentUser?.uid 값이에오: ", Auth.auth().currentUser?.uid)
        print("키체인에 있던 유저의 UUID 값이에오: ", UserManager.shared.user.userUUID)
        configurePushNotification(application)
        configureMessaging()
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    private func configurePushNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        guard let feedUUID = userInfo[NotificationKey.feedUUID] as? String else { return }
        UserDefaultsManager.save(notificationFeedUUID: feedUUID)
        NotificationCenter.default.post(name: .Push, object: nil, userInfo: userInfo)
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    private func configureMessaging() {
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let token = token,
               let savedToken = UserDefaultsManager.fcmToken(),
               token != savedToken {
                // TODO: 삭제
                print("현재 UserManager에 있는 userUUID", UserManager.shared.user.userUUID)
                print("의 토큰 값: ", token)
                print("저장되어있던 토큰 값: ", savedToken)
                UserDefaultsManager.save(fcmToken: token)
                FirebaseFCMToken.save(fcmToken: token, to: UserManager.shared.user.userUUID)
            }
        }
    }

    // token refresh monitoring
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        if let fcmToken = fcmToken {
            print("리프레쉬 fcmToken", fcmToken)
            if UserManager.shared.user.userUUID.isEmpty {
                UserDefaultsManager.save(fcmToken: fcmToken)
            } else {
                FirebaseFCMToken.save(fcmToken: fcmToken, to: UserManager.shared.user.userUUID)
            }
        }
    }
}

// MARK: - save user in keychain
// TODO: https://medium.com/cashwalk/ios-background-mode-9bf921f1c55b
extension AppDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaultsManager.removeAllEtags()
        KeyChainManager.deleteUser()
        KeyChainManager.save(user: UserManager.shared.user)
    }
}
