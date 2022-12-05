//
//  AppCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showAuthFlow()
    func showTabBarFlow()
    func showTabBarFlowByPushNotifiaction(feedUUID: String)
}

final class AppCoordinator: AppCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        configureNavigationBar()
        addObserver()
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
        UserManager.shared.start()
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

    func showTabBarFlowByPushNotifiaction(feedUUID: String) {
        if let tabBarCoordinator = tabBarCoordinator() {
            tabBarCoordinator.moveToDetailScreen(feedUUID: feedUUID)
        } else {
            showTabBarFlow()
            if let tabBarCoordinator = tabBarCoordinator() {
                tabBarCoordinator.moveToDetailScreen(feedUUID: feedUUID)
            }
        }
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receivePushNotification(_:)),
            name: .Push,
            object: nil
        )
    }

    @objc private func receivePushNotification(_ notification: Notification) {
        guard let feedUUID = notification.userInfo?[NotificationKey.feedUUID] as? String
        else { return }
        showTabBarFlowByPushNotifiaction(feedUUID: feedUUID)
    }

    private func tabBarCoordinator() -> TabBarCoordinator? {
        if let childCoordinator = childCoordinators.first(where: { $0 is TabBarCoordinator }),
           let tabBarCoordinator = childCoordinator as? TabBarCoordinator {
            return tabBarCoordinator
        }
        return nil
    }

    private func configureNavigationBar() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .background
            self.navigationController.navigationBar.standardAppearance = navigationBarAppearance
            self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        }
    }
}
