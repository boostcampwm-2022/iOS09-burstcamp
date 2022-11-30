//  TabCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

import Then

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    var currentPage: TabBarPage? { get }

    func selectPage(_ page: TabBarPage)

    func moveToMyPageEditScreen(myPageViewController: MyPageViewController)
    func moveToOpenSourceScreen()
    func moveToAuthFlow()
    func moveMyPageEditScreenToBackScreen(
        myPageViewController: MyPageViewController,
        toastMessage: String
    )

    func moveToDetailScreen(feedUUID: String)
}

final class TabBarCoordinator: TabBarCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController = UITabBarController()
    var coordinatorPublisher = PassthroughSubject<AppCoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()

    var currentPage: TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let controllers = [TabBarPage.myPage, TabBarPage.bookmark, TabBarPage.home]
            .sorted { $0.index < $1.index }
            .map { prepareTabController($0) }

        configureTabBarController(with: controllers)
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
            let homeFireStore = HomeFireStoreService()
            let homeViewModel = HomeViewModel(homeFireStore: homeFireStore)
            controller = HomeViewController(viewModel: homeViewModel)
        case .bookmark:
            let scrapPageViewModel = ScrapPageViewModel()
            controller = ScrapPageViewController(viewModel: scrapPageViewModel)
        case .myPage:
            controller = prepareMyPageViewController()
        }
        configureTabBarItem(of: controller, with: page)
        return controller
    }

    private func prepareMyPageViewController() -> MyPageViewController {
        let viewModel = MyPageViewModel()
        let myPageViewController = MyPageViewController(viewModel: viewModel)

        myPageViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveToAuthFlow: self?.moveToAuthFlow()
                case .moveToMyPageEditScreen: self?.moveToMyPageEditScreen(
                    myPageViewController: myPageViewController
                )
                case .moveToOpenSourceScreen: self?.moveToOpenSourceScreen()
                default: break
                }
            }
            .store(in: &cancelBag)

        return myPageViewController
    }

    private func prepareMyPageEditViewController(
        myPageViewController: MyPageViewController
    ) -> MyPageEditViewController {
        let viewModel = MyPageEditViewModel()
        let myPageEditViewController = MyPageEditViewController(viewModel: viewModel)

        myPageEditViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveMyPageEditScreenToBackScreen(let toastMessage):
                    self?.moveMyPageEditScreenToBackScreen(
                        myPageViewController: myPageViewController,
                        toastMessage: toastMessage
                    )
                default: break
                }
            }
            .store(in: &cancelBag)

        return myPageEditViewController
    }
}

// MARK: - MyPageEvent

extension TabBarCoordinator {

    func moveToMyPageEditScreen(myPageViewController: MyPageViewController) {
        let myPageEditViewController = prepareMyPageEditViewController(
            myPageViewController: myPageViewController
        )
        navigationController.pushViewController(myPageEditViewController, animated: true)
    }

    func moveToOpenSourceScreen() {
        let openSourceLicenseViewController = OpenSourceLicenseViewController()
        navigationController.pushViewController(openSourceLicenseViewController, animated: true)
    }

    func moveToAuthFlow() {
        finish()
        coordinatorPublisher.send(.moveToAuthFlow)
    }

    func moveMyPageEditScreenToBackScreen(
        myPageViewController: MyPageViewController,
        toastMessage: String
    ) {
        navigationController.popViewController(animated: true)
        myPageViewController.toastMessagePublisher.send(toastMessage)
    }
}

// MARK: - Push Notification

extension TabBarCoordinator {

    func moveToDetailScreen(feedUUID: String) {
//        let detailViewController = FeedDetailViewController(feedUUID: feedUUID)
//        navigationController.pushViewController(detailViewController, animated: true)
    }
}
