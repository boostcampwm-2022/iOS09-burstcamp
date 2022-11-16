//  TabCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

protocol TabBarCoordinatorProtocol: CoordinatorPublisher {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: TabBarCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    var disposableBag = Set<AnyCancellable>()

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        tabBarController = UITabBarController()
    }

    func start() {
        let pages: [TabBarPage] = [.myPage, .bookmark, .home]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })

        let controllers: [UINavigationController] = pages.map({ prepareTabController($0) })

        prepareTabBarController(with: controllers)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    func currentPage() -> TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }

    private func prepareTabBarController(with tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.tabBar.backgroundColor = .white
        // TODO: TabBar 설정 각자 View에서 처리
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }

    private func prepareTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        // TODO: NavigationBar 설정 각자 View에서 처리
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem(
            title: page.pageTitle(),
            image: UIImage(systemName: page.pageIconTitle()),
            tag: page.pageOrderNumber()
        )

        switch page {
        case .home:
            let homeViewController = HomeViewController()
            navigationController.pushViewController(homeViewController, animated: true)
        case .bookmark:
            let bookmarkViewController = BookmarkViewController()
            navigationController.pushViewController(bookmarkViewController, animated: true)
        case .myPage:
            let myPageViewController = MyPageViewController()
            myPageViewController
                .coordinatrPublisher
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
            navigationController.pushViewController(myPageViewController, animated: true)
        }

        return navigationController
    }
}
