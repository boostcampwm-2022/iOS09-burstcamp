//  TabCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

import Then

protocol TabBarCoordinatorProtocol: NormalCoordinator {
    var tabBarController: UITabBarController { get set }
    var currentPage: TabBarPage? { get }

    func selectPage(_ page: TabBarPage)
}

final class TabBarCoordinator: TabBarCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController = UITabBarController()
    var coordinatorPublisher = PassthroughSubject<AppCoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()
    var dependencyFactory: DependencyFactoryProtocol

    var currentPage: TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }

    init(navigationController: UINavigationController, dependencyFactory: DependencyFactoryProtocol) {
        self.navigationController = navigationController
        self.dependencyFactory = dependencyFactory
        addObserver()
    }

    func start() {
        let controllers = [TabBarPage.myPage, TabBarPage.scrapPage, TabBarPage.home]
            .sorted { $0.index < $1.index }
            .map { prepareTabController($0) }

        configureTabBarController(with: controllers)
        moveToFeedDetail()
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.index
    }

    private func configureTabBarController(with tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.index
        tabBarController.tabBar.backgroundColor = .background
        tabBarController.tabBar.tintColor = .main
        tabBarController.tabBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .background
            tabBarController.tabBar.standardAppearance = tabBarAppearance
        }
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
            controller = homeCoordinatorStart()
        case .scrapPage:
            controller = scrapPageCoordinatorStart()
        case .myPage:
            controller = myPageCoordinatorStart()
        }
        configureTabBarItem(of: controller, with: page)
        return controller
    }

    private func homeCoordinatorStart() -> HomeViewController {
        let homeViewModel = dependencyFactory.createHomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, dependencyFactory: dependencyFactory)
        homeCoordinator.start(viewController: homeViewController)
        childCoordinators.append(homeCoordinator)
        return homeViewController
    }

    private func scrapPageCoordinatorStart() -> ScrapPageViewController {
        let scrapPageViewModel = dependencyFactory.createScrapPageViewModel()
        let scrapPageViewController = ScrapPageViewController(viewModel: scrapPageViewModel)
        let scrapCoordinator = ScrapPageCoordinator(
            navigationController: navigationController,
            dependencyFactory: dependencyFactory
        )
        scrapCoordinator.start(viewController: scrapPageViewController)
        childCoordinators.append(scrapCoordinator)
        return scrapPageViewController
    }

    private func myPageCoordinatorStart() -> MyPageViewController {
        let myPageViewModel = dependencyFactory.createMyPageViewModel()
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        let myPageCoordinator = MyPageCoordinator(
            navigationController: navigationController,
            dependencyFactory: dependencyFactory
        )
        myPageCoordinator.coordinatorPublisher
            .sink { tabBarEvent in
                switch tabBarEvent {
                case .moveToAuthFlow:
                    self.coordinatorPublisher.send(.moveToAuthFlow)
                }
            }
            .store(in: &cancelBag)

        myPageCoordinator.start(viewController: myPageViewController)
        childCoordinators.append(myPageCoordinator)
        return myPageViewController
    }
}

extension TabBarCoordinator {
    func getHomeCoordinator() -> HomeCoordinator? {
        let homeCoordinator = childCoordinators.first {
            type(of: $0) == HomeCoordinator.self
        } as? HomeCoordinator
        return homeCoordinator
    }
}

// MARK: - handle Push Notification

extension TabBarCoordinator: ContainFeedDetailCoordinator {
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveToFeedDetail),
            name: .Push,
            object: nil
        )
    }

    @objc func moveToFeedDetail() {
        if let feedUUID = UserDefaultsManager.notificationFeedUUID() {
            UserDefaultsManager.removeNotificationFeedUUID()
            let feedDetailViewController = prepareFeedDetailViewController(feedUUID: feedUUID)
            sinkFeedViewController(feedDetailViewController)
            navigationController.pushViewController(feedDetailViewController, animated: true)
        }
    }
}
