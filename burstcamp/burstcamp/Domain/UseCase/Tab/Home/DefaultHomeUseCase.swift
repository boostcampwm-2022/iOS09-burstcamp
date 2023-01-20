//
//  DefaultHomeUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultHomeUseCase: HomeUseCase {

    private let feedRepository: FeedRepository

    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }

    func fetchRecentHomeFeedList() async throws -> HomeFeedList {
        return try await feedRepository.fetchRecentHomeFeedList()
    }

    func fetchMoreNormalFeed() async throws -> [Feed] {
        return try await feedRepository.fetchMoreNormalFeed()
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws {
        try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }

    func unScrapFeed(_ feed: Feed, userUUID: String) async throws {
        try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }
}
