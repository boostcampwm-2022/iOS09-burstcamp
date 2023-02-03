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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var notificationUseCase: NotificationUseCase!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        BCFirebaseApp.startApp()
        createNotificationUseCase()
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

    private func createNotificationUseCase() {
        let dependencyFactory = DependencyFactory()
        self.notificationUseCase = dependencyFactory.createNotificationUseCase()
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
                do {
                    try await self?.notificationUseCase.saveIfDifferentFromTheStoredToken(fcmToken: token)
                } catch {
                    self?.handleError(error, message: "토큰 configure 에러")
                }
            }
        }
    }

    // token refresh monitoring
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        handleRefreshToken(fcmToken: fcmToken)
    }

    private func handleRefreshToken(fcmToken: String?) {
        if let fcmToken = fcmToken {
            Task { [weak self] in
                do {
                    try await self?.notificationUseCase.refresh(fcmToken: fcmToken)
                } catch {
                    self?.handleError(error, message: "Token Refresh 에러")
                }
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

// MARK: - Error -> Alert
extension AppDelegate {
    func handleError(_ error: Error, message: String) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let errorMessage = message + error.localizedDescription
        if let presentViewController = window.rootViewController {
            presentViewController.showAlert(message: errorMessage)
        } else {
            fatalError(errorMessage)
        }
    }
}
