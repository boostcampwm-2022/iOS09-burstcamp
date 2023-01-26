//
//  DefaultHomeUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultHomeUseCase: HomeUseCase {

    private let feedRepository: FeedRepository
    private let userRepository: UserRepository

    init(feedRepository: FeedRepository, userRepository: UserRepository) {
        self.feedRepository = feedRepository
        self.userRepository = userRepository
    }

    func fetchRecentHomeFeedList() async throws -> HomeFeedList {
        let userScrapFeedUUIDs = UserManager.shared.user.scrapFeedUUIDs
        let homeFeedList = try await feedRepository.fetchRecentHomeFeedList()
        let normalFeed = homeFeedList.normalFeed.map({ feed in
            return userScrapFeedUUIDs.contains(feed.feedUUID) ? feed.setIsScraped(true) : feed
        })
        let recommendFeed = recommendFeedForCarousel(homeFeedList.recommendFeed)
        return HomeFeedList(recommendFeed: recommendFeed, normalFeed: normalFeed)
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

    func updateUserPushState(to pushState: Bool) async throws {
        let userUUID = UserManager.shared.user.userUUID
        if !userUUID.isEmpty {
            try await userRepository.updateUserPushState(userUUID: userUUID, isPushOn: pushState)
        }
    }

    // Carousel View를 위해 추천 피드를 2개 씩 복사해줘야 함
    private func recommendFeedForCarousel(_ recommendFeedList: [Feed]) -> [Feed] {
        let newArrayOne = makeMockUpRecommendFeed(recommendFeedList)
        let newArrayTwo = makeMockUpRecommendFeed(recommendFeedList)
        return newArrayOne + recommendFeedList + newArrayTwo
    }

    private func makeMockUpRecommendFeed(_ recommendFeedList: [Feed]) -> [Feed] {
        return recommendFeedList.map {
            return $0.getMockUpFeed()
        }
    }
}
