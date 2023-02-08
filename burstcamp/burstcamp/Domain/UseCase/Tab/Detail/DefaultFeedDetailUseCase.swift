//
//  DefaultFeedDetailUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultFeedDetailUseCase: FeedDetailUseCase {

    private let feedRepository: FeedRepository

    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }

    func fetchFeed(by feedUUID: String) async throws -> Feed {
        return try await feedRepository.fetchFeed(by: feedUUID)
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return feed.isScraped
        ? try await feedRepository.unScrapFeed(feed, userUUID: userUUID)
        : try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }

    func blockFeed(_ feed: Feed) async throws {
        let user = UserManager.shared.user
        let wasScraped = user.scrapFeedUUIDs.contains(feed.feedUUID)

        try await feedRepository.blockFeed(feed, userUUID: user.userUUID, wasScraped: wasScraped)
    }

    func reportFeed(_ feed: Feed) async throws {
        let user = UserManager.shared.user
        let wasScraped = user.scrapFeedUUIDs.contains(feed.feedUUID)

        try await feedRepository.reportFeed(feed, userUUID: user.userUUID)
        try await feedRepository.blockFeed(feed, userUUID: user.userUUID, wasScraped: wasScraped)
    }
}
