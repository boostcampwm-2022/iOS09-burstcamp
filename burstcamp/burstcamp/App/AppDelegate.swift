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

    private var notificationUseCase: NotificationUseCase!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        makeDependency()
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
        notificationUseCase.didReceiveNotification(response: response)
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    private func configureMessaging() {
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            Task { [weak self] in
                try await self?.notificationUseCase.saveIfDifferentFromTheStoredToken(fcmToken: token)
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
            Task {
                try await notificationUseCase.refresh(fcmToken: fcmToken)
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

extension AppDelegate {
    func makeDependency() {
        let userDefaultsService = DefaultUserDefaultsService()
        let bcFireStoreService = BCFirestoreService()
        let notificationRepository = DefaultNotificationRepository(
            userDefaultsService: userDefaultsService,
            bcFirestoreService: bcFireStoreService
        )
        notificationUseCase = DefaultNotificationUseCase(notificationRepository: notificationRepository)
    }
}
