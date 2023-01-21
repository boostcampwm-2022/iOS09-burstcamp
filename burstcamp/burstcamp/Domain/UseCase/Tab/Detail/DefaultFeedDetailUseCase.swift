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

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return feed.isScraped
        ? try await feedRepository.unScrapFeed(feed, userUUID: userUUID)
        : try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }
}
