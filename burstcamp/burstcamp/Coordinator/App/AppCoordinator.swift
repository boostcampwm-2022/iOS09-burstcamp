//
//  AppCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

protocol AppCoordinatorProtocol: NormalCoordinator {
    func showAuthFlow()
    func showTabBarFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        configureNavigationBar()
    }

    func dismissNavigationController() {
        navigationController.dismiss(animated: true)
    }

    func displayIndicator() {
        guard let authCoordinator = childCoordinators.first(
            where: { $0 is AuthCoordinator }) as? AuthCoordinator
        else {
            return
        }
        authCoordinator.displayIndicator()
    }

    func start() {
        LogInManager.shared.autoLogInPublisher
            .sink { [weak self] isLogIn in
                if isLogIn {
                    self?.showTabBarFlow()
                } else {
                    self?.showAuthFlow()
                }
            }
            .store(in: &cancelBag)
        LogInManager.shared.isLoggedIn()
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
        UserManager.shared.addListener()
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

    private func configureNavigationBar() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .background
            navigationBarAppearance.shadowColor = .background
            self.navigationController.navigationBar.standardAppearance = navigationBarAppearance
            self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        }
    }
}
