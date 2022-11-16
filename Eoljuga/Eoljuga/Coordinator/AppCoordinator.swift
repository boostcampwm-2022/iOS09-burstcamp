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
    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
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
                if coordinatorEvent == .moveToTabBarFlow {
                    self.finish(childCoordinator: authCoordinator)
                    self.showTabBarFlow()
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
                if coordinatorEvent == .moveToAuthFlow {
                    self.finish(childCoordinator: tabBarCoordinator)
                    self.showAuthFlow()
                }
            }
            .store(in: &disposableBag)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
