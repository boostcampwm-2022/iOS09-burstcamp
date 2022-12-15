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

    func prepareFeedDetailViewController(feed: Feed) -> FeedDetailViewController {
        let feedDetailViewModel = FeedDetailViewModel(feed: feed)
        let scrapViewModel = ScrapViewModel(
            feedUUID: feed.feedUUID,
            feedLocalDataSource: FeedLocalDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
        let feedDetailViewController = FeedDetailViewController(
            feedDetailViewModel: feedDetailViewModel,
            scrapViewModel: scrapViewModel
        )
        return feedDetailViewController
    }

    func prepareFeedDetailViewController(feedUUID: String) -> FeedDetailViewController {
        let feedDetailViewModel = FeedDetailViewModel(feedUUID: feedUUID)
        let scrapViewModel = ScrapViewModel(
            feedUUID: feedUUID,
            feedLocalDataSource: FeedLocalDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
        let feedDetailViewController = FeedDetailViewController(
            feedDetailViewModel: feedDetailViewModel,
            scrapViewModel: scrapViewModel
        )
        return feedDetailViewController
    }
}
