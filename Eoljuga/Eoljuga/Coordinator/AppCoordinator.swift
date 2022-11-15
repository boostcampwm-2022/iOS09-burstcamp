//
//  AppCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if isLogin() {
            toTabBar()
        } else {
            toAuth()
        }
    }

    func isLogin() -> Bool {
        return true
    }

    func toTabBar() {
        let tabCoordinator = TabCoordinator(navigationController)
        childCoordinator.append(tabCoordinator)
        tabCoordinator.start()
    }

    func toAuth() {
        let authCoordinator = AuthCoordinator(navigationController)
        childCoordinator.append(authCoordinator)
        authCoordinator.start()
    }
}
