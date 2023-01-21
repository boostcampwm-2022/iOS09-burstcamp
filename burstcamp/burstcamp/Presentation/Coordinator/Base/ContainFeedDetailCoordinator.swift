//
//  ContainFeedDetailCoordinator.swift
//  burstcamp
//
//  Created by youtak on 2022/12/07.
//

import Combine
import SafariServices.SFSafariViewController
import UIKit

/// FeedDetail Screen을 가지는 Coordinator가 채택함
protocol ContainFeedDetailCoordinator: Coordinator { }

extension ContainFeedDetailCoordinator {
    func moveToBlogSafari(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        self.navigationController.present(safariViewController, animated: true)
    }

    func sinkFeedViewController(_ feedDetailViewController: FeedDetailViewController) {
        feedDetailViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveToBlogSafari(let url):
                    self?.moveToBlogSafari(url: url)
                }
            }
            .store(in: &cancelBag)
    }

    func sink(_ feedDetailViewController: FeedDetailViewController, homeViewController: HomeViewController) {
        let updateFeedPublisher = feedDetailViewController.getUpdateFeedPublisher()
        homeViewController.configure(scrapUpdatePublisher: updateFeedPublisher)
    }

    func prepareFeedDetailViewController(feed: Feed) -> FeedDetailViewController {
        let feedDetailViewModel = dependencyFactory.createFeedDetailViewModel(feed: feed)
        let scrapViewModel = ScrapViewModel(
            feedUUID: feed.feedUUID
        )
        let feedDetailViewController = FeedDetailViewController(
            feedDetailViewModel: feedDetailViewModel,
            scrapViewModel: scrapViewModel
        )
        return feedDetailViewController
    }

    func prepareFeedDetailViewController(feedUUID: String) -> FeedDetailViewController {
        let feedDetailViewModel = dependencyFactory.createFeedDetailViewModel(feedUUID: feedUUID)
        let scrapViewModel = ScrapViewModel(
            feedUUID: feedUUID
        )
        let feedDetailViewController = FeedDetailViewController(
            feedDetailViewModel: feedDetailViewModel,
            scrapViewModel: scrapViewModel
        )
        return feedDetailViewController
    }
}
