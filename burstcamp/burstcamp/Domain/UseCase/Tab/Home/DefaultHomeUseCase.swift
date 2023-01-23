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
            return userScrapFeedUUIDs.contains(feed.feedUUID) ? feed.setIsScraped(true) : feed
        })
        print("스크랩 배열", userScrapFeedUUIDs)
        normalFeed.forEach { feed in
            print("Use 케이스에서 출력", feed.title, feed.isScraped)
        }
        return HomeFeedList(recommendFeed: homeFeedList.recommendFeed, normalFeed: normalFeed)
    }

    func fetchMoreNormalFeed() async throws -> [Feed] {
        let userScrapFeedUUIDs = UserManager.shared.user.scrapFeedUUIDs
        return try await feedRepository.fetchMoreNormalFeed().map { feed in
            return userScrapFeedUUIDs.contains(feed.feedUUID) ? feed.setIsScraped(true) : feed
        }
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return feed.isScraped
        ? try await feedRepository.unScrapFeed(feed, userUUID: userUUID)
        : try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }
}
