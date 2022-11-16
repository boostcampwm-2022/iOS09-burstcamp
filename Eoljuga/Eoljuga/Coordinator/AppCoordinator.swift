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
    var disposableBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        return isLoggedIn() ? showTabBarFlow() : showAuthFlow()
    }

    func isLoggedIn() -> Bool {
        return true
    }

    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator
            .coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToTabBarFlow:
                    self.remove(childCoodridnator: authCoordinator)
                    self.showTabBarFlow()
                case .moveToAuthFlow:
                    return
                }
            }
            .store(in: &disposableBag)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }

    func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator
            .coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToTabBarFlow:
                    return
                case .moveToAuthFlow:
                    self.remove(childCoodridnator: tabBarCoordinator)
                    self.showAuthFlow()
                }
            }
            .store(in: &disposableBag)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
