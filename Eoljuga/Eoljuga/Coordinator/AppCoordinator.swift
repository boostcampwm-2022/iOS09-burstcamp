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
        }
    }

    func isLogin() -> Bool {
        return true
    }

    func toTabBar() {
        let tabCoordinator = TabCoordinator(navigationController)
        tabCoordinator.start()
    }
}
