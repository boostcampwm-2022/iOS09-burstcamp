//
//  DefaultFeedRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/03.
//

import Foundation

final class DefaultFeedRepository: FeedRepository {

    private let bcFirestoreService: BCFirestoreService

    init(bcFirestoreService: BCFirestoreService) {
        self.bcFirestoreService = bcFirestoreService
    }

    func fetchRecentHomeFeedList() async throws -> HomeFeedList {
        async let recommendFeed = bcFirestoreService.fetchRecommendFeed().map { Feed(feedAPIModel: $0) }
        async let normalFeed = bcFirestoreService.fetchLatestNormalFeeds().map { Feed(feedAPIModel: $0) }
        return HomeFeedList(
            recommendFeed: try await recommendFeed,
            normalFeed: try await normalFeed
        )
    }

    func fetchMoreNormalFeed() async throws -> [Feed] {
        return try await bcFirestoreService.fetchMoreNormalFeeds().map { Feed(feedAPIModel: $0) }
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws {
        try await bcFirestoreService.scrapFeed(FeedAPIModel(feed: feed), with: userUUID)
    }

    func unScrapFeed(_ feed: Feed, userUUID: String) async throws {
        try await bcFirestoreService.unScrapFeed(FeedAPIModel(feed: feed), with: userUUID)
    }
}
