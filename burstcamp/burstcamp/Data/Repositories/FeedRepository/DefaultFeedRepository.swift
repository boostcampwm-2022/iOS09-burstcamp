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

    // MARK: - Home Feed 불러오기
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

    // MARK: - Scrap 피드 불러오기
    func fetchRecentScrapFeed(userUUID: String) async throws -> [Feed] {
        return try await bcFirestoreService.fetchLatestScrapFeeds(userUUID: userUUID).map {
            Feed(feedAPIModel: $0, isScraped: true)
        }
    }

    func fetchMoreScrapFeed(userUUID: String) async throws -> [Feed] {
        return try await bcFirestoreService.fetchMoreScrapFeeds(userUUID: userUUID).map {
            Feed(feedAPIModel: $0, isScraped: true)
        }
    }

    // MARK: 피드 스크랩
    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        let scrapedFeed = feed.getScrapFeed()
        try await bcFirestoreService.scrapFeed(ScrapFeedAPIModel(feed: scrapedFeed), with: userUUID)
        return scrapedFeed
    }

    func unScrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        let unScrapedFeed = feed.getUnScrapFeed()
        try await bcFirestoreService.unScrapFeed(FeedAPIModel(feed: unScrapedFeed), with: userUUID)
        return unScrapedFeed
    }
}
