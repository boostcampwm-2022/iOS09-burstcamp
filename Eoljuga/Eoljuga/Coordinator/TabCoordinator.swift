//
//  TabCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

enum TabBarPage {
    case home
    case bookmark
    case myPage

    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .bookmark
        case 2: self = .myPage
        default: return nil
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .bookmark: return 1
        case .myPage: return 2
        }
    }
}

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabCoordinator: NSObject, TabCoordinatorProtocol {
    var childCoordinator: [Coordinator] = []
    var navigationCotroller: UINavigationController
    var tabBarController: UITabBarController
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .tab

    required init(_ navigationController: UINavigationController) {
        self.navigationCotroller = navigationController
        tabBarController = UITabBarController()
    }

    func start() {
        let pages: [TabBarPage] = [.myPage, .bookmark, .home]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })

        let controllers: [UINavigationController] = pages.map({ getTabController($0) })

        prepareTabBarController(withTabControllers: controllers)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarController.selectedIndex)
    }

    private func prepareTabBarController(withTabControllers tabBarControllers: [UIViewController]) {
        self.tabBarController.delegate = self
        self.tabBarController.setViewControllers(tabBarControllers, animated: true)
//        self.tabBarController.selectedIndex = TabBarPage
        self.tabBarController.tabBar.isTranslucent = false
        navigationCotroller.viewControllers = [tabBarController]
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem(
            title: "home",
            image: nil,
            tag: page.pageOrderNumber()
        )

        switch page {
        case .home:
            let homeViewController = HomeViewController()
            self.navigationCotroller.pushViewController(homeViewController, animated: true)
        case .bookmark:
            let bookmarkViewController = BookmarkViewController()
            self.navigationCotroller.pushViewController(bookmarkViewController, animated: true)
        case .myPage:
            let myPageViewController = MyPageViewController()
            self.navigationCotroller.pushViewController(myPageViewController, animated: true)
        }

        return navigationController
    }
}

extension TabCoordinator: UITabBarControllerDelegate {
}
