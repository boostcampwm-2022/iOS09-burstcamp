//
//  DefaultHomeUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultHomeUseCase: HomeUseCase {

    private let recommendFeedCount = 3

    private let feedRepository: FeedRepository
    private let userRepository: UserRepository
    private var scarpFeedUUID: [String: String]
    private var reportFeedUUID: [String: String]

    init(feedRepository: FeedRepository, userRepository: UserRepository) {
        self.feedRepository = feedRepository
        self.userRepository = userRepository
        self.scarpFeedUUID = [:]
        self.reportFeedUUID = [:]
    }

    func fetchRecentHomeFeedList() async throws -> HomeFeedList {
        let homeFeedList = try await feedRepository.fetchRecentHomeFeedList()

        let filterReportFeed = filterReportFeed(homeFeedList.normalFeed)
        let filterScarpFeed = filterScrapFeed(filterReportFeed)

        let recommendFeed = addBurstcampNoticeIfNeed(recommendFeedList: homeFeedList.recommendFeed)
        let tripleRecommendFeed = recommendFeedForCarousel(recommendFeed)
        return HomeFeedList(recommendFeed: tripleRecommendFeed, normalFeed: filterScarpFeed)
    }

    func fetchMoreNormalFeed() async throws -> [Feed] {
        let normalFeed = try await feedRepository.fetchMoreNormalFeed()
        let filterReportFeed = filterReportFeed(normalFeed)
        let filterScarpFeed = filterScrapFeed(filterReportFeed)
        return filterScarpFeed
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

    // MARK: RecommendFeed가 없는 경우 버스트 캠프 공지

    private func addBurstcampNoticeIfNeed(recommendFeedList: [Feed]) -> [Feed] {
        let noticeFeed = feedRepository.createMockUpRecommendFeedList(count: self.recommendFeedCount - recommendFeedList.count)
        return recommendFeedList + noticeFeed
    }

    // MARK: - Carousel View를 위해 추천 피드를 2개씩 복사해줘야 함

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

    private func arrayToDictionary(reportFeedList: [String]) -> [String: String] {
        return Dictionary(uniqueKeysWithValues: reportFeedList.map { ($0, $0)})
    }

    // MARK: 스크랩 피드 필터링

    private func updateScrapFeedUUID() {
        self.scarpFeedUUID = arrayToDictionary(reportFeedList: UserManager.shared.user.scrapFeedUUIDs)
    }

    private func filterScrapFeed(_ feedList: [Feed]) -> [Feed] {
        updateScrapFeedUUID()
        return feedList.map { feed in
            return scarpFeedUUID[feed.feedUUID] != nil ? feed.setIsScraped(true) : feed
        }
    }

    // MARK: - 차단 피드 필터링

    private func updateReportFeedUUID() {
        self.reportFeedUUID = arrayToDictionary(reportFeedList: UserManager.shared.user.reportFeedUUIDs)
    }

    private func filterReportFeed(_ feedList: [Feed]) -> [Feed] {
        updateReportFeedUUID()
        return feedList.filter { feed in
            return reportFeedUUID[feed.feedUUID] == nil ? true: false
        }
    }
}
