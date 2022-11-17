//  TabCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

import Then

protocol TabBarCoordinatorProtocol: CoordinatorPublisher {
    var tabBarController: UITabBarController { get set }
    var currentPage: TabBarPage? { get }

    func selectPage(_ page: TabBarPage)
}

final class TabBarCoordinator: TabBarCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController = UITabBarController()
    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    var disposableBag = Set<AnyCancellable>()

    var currentPage: TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let controllers = [TabBarPage.myPage, TabBarPage.bookmark, TabBarPage.home]
            .sorted(by: { $0.index < $1.index })
            .map({ prepareTabController($0) })

        configureTabBarController(with: controllers)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.index
    }

    private func configureTabBarController(with tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.index
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }

    private func configureTabBarItem(of viewController: UIViewController, with page: TabBarPage) {
        viewController.tabBarItem = UITabBarItem(
            title: page.pageTitle,
            image: UIImage(systemName: page.pageIconTitle),
            tag: page.index
        )
    }

    private func prepareTabController(_ page: TabBarPage) -> UIViewController {
        var controller: UIViewController
        switch page {
        case .home:
            controller = HomeViewController()
        case .bookmark:
            controller = BookmarkViewController()
        case .myPage:
            let myPageViewController = MyPageViewController()
            myPageViewController.coordinatorPublisher
                .sink { coordinatorEvent in
                    switch coordinatorEvent {
                    case .moveToAuthFlow:
                        self.finish()
                        self.coordinatorPublisher.send(.moveToAuthFlow)
                    case .moveToTabBarFlow:
                        return
                    }
                }
                .store(in: &disposableBag)
            controller = myPageViewController
        }
        configureTabBarItem(of: controller, with: page)
        return controller
    }
}
