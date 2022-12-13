//
//  SceneDelegate.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/15.
//

import UIKit

import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
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
        window?.backgroundColor = .background
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        addLoadingView(window: window, navigationController: navigationController)
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
    }

    private func addLoadingView(window: UIWindow?, navigationController: UINavigationController) {
        let systemIsDarkMode = navigationController.traitCollection.isDarkMode
        let loadingView = LoadingView(systemIsDarkMode: systemIsDarkMode)
        guard let window = window else {
            return
        }
        window.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        UIView.animate(withDuration: 1.5, delay: 0) {
            loadingView.alpha = 0
        }
        UIView.animate(withDuration: 1.0) {
            loadingView.alpha = 0
        } completion: { isFinished in
            if isFinished {
                loadingView.removeFromSuperview()
            }
        }
    }

    private func setInitialDarkMode() {
        DarkModeManager.currentAppearance = UserDefaultsManager.currentAppearance()
    }
}
