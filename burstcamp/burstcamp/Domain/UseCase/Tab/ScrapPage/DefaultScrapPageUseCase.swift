//
//  DefaultScrapPageUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultScrapPageUseCase: ScrapPageUseCase {

    private let feedRepository: FeedRepository

    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }

    func fetchRecentScrapFeed() async throws -> [Feed] {
        let userUUID = UserManager.shared.user.userUUID
        return try await feedRepository.fetchRecentScrapFeed(userUUID: userUUID)
    }

    func fetchMoreScrapFeed() async throws -> [Feed] {
        let userUUID = UserManager.shared.user.userUUID
        return try await feedRepository.fetchMoreScrapFeed(userUUID: userUUID)
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return feed.isScraped
        ? try await feedRepository.unScrapFeed(feed, userUUID: userUUID)
        : try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }
}
