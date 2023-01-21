//
//  HomeCoordinator.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import Combine
import UIKit

protocol HomeCoordinatorProtocol: TabBarChildCoordinator {
//    func moveToFeedDetail(feed: Feed)
    func moveToFeedDetail(feedUUID: String)
    func moveToBlogSafari(url: URL)
}

final class HomeCoordinator: HomeCoordinatorProtocol, ContainFeedDetailCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var cancelBag = Set<AnyCancellable>()
    var dependencyFactory: DependencyFactoryProtocol

    init(navigationController: UINavigationController, dependencyFactory: DependencyFactoryProtocol) {
        self.navigationController = navigationController
        self.dependencyFactory = dependencyFactory
    }
}

extension HomeCoordinator {
    func start(viewController: UIViewController) {
        guard let homeViewController = viewController as? HomeViewController else {
            return
        }

        homeViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveToFeedDetail(let feed):
                    self?.moveToFeedDetail(feed: feed, homeViewController: homeViewController)
                }
            }
            .store(in: &cancelBag)
    }

    func moveToFeedDetail(feed: Feed, homeViewController: HomeViewController) {
        let feedDetailViewController = prepareFeedDetailViewController(feed: feed)
        sinkFeedViewController(feedDetailViewController)
        sink(feedDetailViewController, homeViewController: homeViewController)
        self.navigationController.pushViewController(feedDetailViewController, animated: true)
    }

    func moveToFeedDetail(feedUUID: String) {
        let feedDetailViewController = prepareFeedDetailViewController(feedUUID: feedUUID)
        sinkFeedViewController(feedDetailViewController)
        self.navigationController.pushViewController(feedDetailViewController, animated: true)
    }
}
