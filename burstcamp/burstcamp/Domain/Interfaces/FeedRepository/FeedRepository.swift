//
//  FeedRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/03.
//

import Foundation

protocol FeedRepository {
    func fetchRecentHomeFeedList() async throws -> HomeFeedList
    func fetchMoreNormalFeed() async throws -> [Feed]

    func fetchRecentScrapFeed(userUUID: String) async throws -> [Feed]
    func fetchMoreScrapFeed(userUUID: String) async throws -> [Feed]

    func fetchFeed(by feedUUID: String) async throws -> Feed

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed
    func unScrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed

    func createMockUpRecommendFeedList(count: Int) -> [Feed]

    func blockFeed(_ feed: Feed, userUUID: String, wasScraped: Bool) async throws
    func reportFeed(_ feed: Feed, userUUID: String) async throws
}
