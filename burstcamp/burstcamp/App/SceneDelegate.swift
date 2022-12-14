//
//  SceneDelegate.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/15.
//

import UIKit

import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow!
    var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url,
              let code = url.absoluteString.components(separatedBy: "code=").last
        else {
            return
        }
        appCoordinator.dismissNavigationController()

        if LogInManager.shared.isWithdrawal {
            LogInManager.shared.signOut(code: code)
        } else {
            appCoordinator.displayIndicator()
            LogInManager.shared.logIn(code: code)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startApp(windowScene: windowScene)
    }

    private func startApp(windowScene: UIWindowScene) {
        let navigationController = UINavigationController()
        window = UIWindow(windowScene: windowScene)

        setInitialDarkMode()
        window.backgroundColor = .background
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
        appCoordinator.start()
    }

    private func setInitialDarkMode() {
        DarkModeManager.currentAppearance = UserDefaultsManager.currentAppearance()
    }
}
