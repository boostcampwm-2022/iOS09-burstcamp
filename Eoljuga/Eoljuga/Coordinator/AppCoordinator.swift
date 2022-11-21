//
//  AppCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if isLoggedIn() { showTabBarFlow() } else { showAuthFlow() }
    }

    func isLoggedIn() -> Bool {
        return false
    }

    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToTabBarFlow:
                    self.remove(childCoordinator: authCoordinator)
                    self.showTabBarFlow()
                case .moveToAuthFlow:
                    return
                }
            }
            .store(in: &cancelBag)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }

    func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToTabBarFlow:
                    return
                case .moveToAuthFlow:
                    self.remove(childCoordinator: tabBarCoordinator)
                    self.showAuthFlow()
                }
            }
            .store(in: &cancelBag)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
