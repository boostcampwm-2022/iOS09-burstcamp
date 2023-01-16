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

        if let loginViewController = window.rootViewController?.children.first as? LogInViewController { // 로그인
            loginViewController.login(code: code)
        } else { // 탈퇴
            // TODO: MyPageViewController 캐스팅 후 signOut 호출
        } // else 문 설정해서 해당 안되면 fatal Error
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

        let dependencyFactory = DependencyFactory()
        appCoordinator = AppCoordinator(
            window: window,
            navigationController: navigationController,
            dependencyFactory: dependencyFactory
        )
        appCoordinator.start()
    }

    private func setInitialDarkMode() {
        DarkModeManager.currentAppearance = UserDefaultsManager.currentAppearance()
    }
}
