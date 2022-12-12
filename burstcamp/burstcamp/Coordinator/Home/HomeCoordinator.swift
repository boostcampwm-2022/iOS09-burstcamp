//
//  HomeCoordinator.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import Combine
import UIKit

protocol HomeCoordinatorProtocol: TabBarChildCoordinator {
    func moveToFeedDetail(feed: Feed)
    func moveToFeedDetail(feedUUID: String)
    func moveToBlogSafari(url: URL)
}

final class HomeCoordinator: HomeCoordinatorProtocol, ContainFeedDetailCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
                    self?.moveToFeedDetail(feed: feed)
                }
            }
            .store(in: &cancelBag)

        checkNotificationFeed()
    }

    func moveToFeedDetail(feed: Feed) {
        let feedDetailViewController = prepareFeedDetailViewController(feed: feed)
        sinkFeedViewController(feedDetailViewController)
        self.navigationController.pushViewController(feedDetailViewController, animated: true)
    }

    func moveToFeedDetail(feedUUID: String) {
        let feedDetailViewController = prepareFeedDetailViewController(feedUUID: feedUUID)
        sinkFeedViewController(feedDetailViewController)
        self.navigationController.pushViewController(feedDetailViewController, animated: true)
    }
}

// MARK: - handle push notification

extension HomeCoordinator {
    private func checkNotificationFeed() {
        if !UserDefaultsManager.isForeground(),
           let feedUUID = UserDefaultsManager.notificationFeedUUID() {
            UserDefaultsManager.removeNotificationFeedUUID()
            moveToFeedDetail(feedUUID: feedUUID)
        }
    }
}
