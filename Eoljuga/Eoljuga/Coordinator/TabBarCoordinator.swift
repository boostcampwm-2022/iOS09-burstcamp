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
        case 0:
            self = .home
        case 1:
            self = .bookmark
        case 2:
            self = .myPage
        default:
            return nil
        }
    }

    func pageTitle() -> String {
        switch self {
        case .home: return "홈"
        case .bookmark: return "모아보기"
        case .myPage: return "마이페이지"
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

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .tabBar

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.tabBar.backgroundColor = .white
        // TODO: TabBar 설정 각자 View에서 처리
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        // TODO: NavigationBar 설정 각자 View에서 처리
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem(
            title: page.pageTitle(),
            image: nil,
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
            navigationController.pushViewController(myPageViewController, animated: true)
        }

        return navigationController
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
}
