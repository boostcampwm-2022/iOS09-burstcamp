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
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

final class TabBarCoordinator: TabBarCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController = UITabBarController()
    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    var disposableBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let controllers = [TabBarPage.myPage, TabBarPage.bookmark, TabBarPage.home]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
            .map({ prepareTabController($0) })

        configureTabBarController(with: controllers)
//        configureNavigationController()
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

    private func configureTabBarController(with tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.tabBar.backgroundColor = .white
        // TODO: TabBar 설정 각자 View에서 처리
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }

    private func configureTabBarItem(of viewController: UIViewController, with page: TabBarPage) {
//        navigationController.setNavigationBarHidden(false, animated: false)
        viewController.tabBarItem = UITabBarItem(
            title: page.pageTitle(),
            image: UIImage(systemName: page.pageIconTitle()),
            tag: page.pageOrderNumber()
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
            let mypageViewController = MyPageViewController()
            mypageViewController.coordinatorPublisher
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
            controller = mypageViewController
        }
        configureTabBarItem(of: controller, with: page)
        return controller
    }
}
