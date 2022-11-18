//
//  SceneDelegate.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        guard let code = url.absoluteString.components(separatedBy: "code=").last else { return }
        LogInManager.shared.requestAccessToken(code: code)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startApp(windowScene: windowScene)
    }

    private func startApp(windowScene: UIWindowScene) {
        let navigationController = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
    }
}
