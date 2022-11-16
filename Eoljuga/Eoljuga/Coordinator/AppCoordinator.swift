//
//  AppCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        return isLoggedIn() ? showTabBarFlow() : showAuthFlow()
    }

    func isLoggedIn() -> Bool {
        return false
    }

    func showTabBarFlow() {
        let tabCoordinator = TabBarCoordinator(navigationController)
        childCoordinators.append(tabCoordinator)
        tabCoordinator.start()
    }

    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
}
