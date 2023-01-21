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
        return try await bcFirestoreService.fetchMoreNormalFeeds().map { Feed(feedAPIModel: $0)}
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        let scrapedFeed = feed.getScrapFeed()
        try await bcFirestoreService.scrapFeed(ScrapFeedAPIModel(feed: scrapedFeed), with: userUUID)
        return scrapedFeed
    }

    func unScrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        let unScrapedFeed = feed.getUnScrapFeed()
        try await bcFirestoreService.unScrapFeed(FeedAPIModel(feed: feed), with: userUUID)
        return unScrapedFeed
    }
}
