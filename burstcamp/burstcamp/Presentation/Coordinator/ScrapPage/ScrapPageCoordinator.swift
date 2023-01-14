//
//  ScrapPageCoordinator.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import Combine
import UIKit

protocol ScrapPageCoordinatorProtocol: TabBarChildCoordinator {
    func moveToFeedDetail(feed: Feed)
}

final class ScrapPageCoordinator: ScrapPageCoordinatorProtocol, ContainFeedDetailCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var cancelBag = Set<AnyCancellable>()
    var dependencyFactory: DependencyFactoryProtocol

    init(navigationController: UINavigationController, dependencyFactory: DependencyFactoryProtocol) {
        self.navigationController = navigationController
        self.dependencyFactory = dependencyFactory
    }
}

extension ScrapPageCoordinator {
    func start(viewController: UIViewController) {
        guard let scrapPageViewController = viewController as? ScrapPageViewController else {
            return
        }

        scrapPageViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveToFeedDetail(let feed):
                    self?.moveToFeedDetail(feed: feed)
                }
            }
            .store(in: &cancelBag)
    }

    func moveToFeedDetail(feed: Feed) {
        let feedDetailViewController = prepareFeedDetailViewController(feed: feed)
        sinkFeedViewController(feedDetailViewController)
        self.navigationController.pushViewController(feedDetailViewController, animated: true)
    }
}
