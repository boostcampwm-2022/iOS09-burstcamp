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
        let userScrapFeedUUIDs = UserManager.shared.user.scrapFeedUUIDs
        let homeFeedList = try await feedRepository.fetchRecentHomeFeedList()
        let normalFeed = homeFeedList.normalFeed.map({ feed in
            if userScrapFeedUUIDs.contains(feed.feedUUID) {
                return feed.setIsScraped(true)
            } else {
                return feed
            }
        })
        return HomeFeedList(recommendFeed: homeFeedList.recommendFeed, normalFeed: normalFeed)
    }

    func fetchMoreNormalFeed() async throws -> [Feed] {
        return try await feedRepository.fetchMoreNormalFeed()
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return feed.isScraped
        ? try await feedRepository.unScrapFeed(feed, userUUID: userUUID)
        : try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }
}
