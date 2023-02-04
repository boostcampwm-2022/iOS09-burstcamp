//
//  DefaultFeedRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/03.
//

import Foundation

import BCFirebase

final class DefaultFeedRepository: FeedRepository {

    private let bcFirestoreService: BCFirestoreService
    private let feedMockUpDataSource: FeedMockUpDataSource

    init(bcFirestoreService: BCFirestoreService, feedMockUpDataSource: FeedMockUpDataSource) {
        self.bcFirestoreService = bcFirestoreService
        self.feedMockUpDataSource = feedMockUpDataSource
    }

    // MARK: - Home Feed 불러오기
    func fetchRecentHomeFeedList() async throws -> HomeFeedList {
        async let recommendFeed = bcFirestoreService.fetchRecommendFeed().map { Feed(feedAPIModel: $0) }

        do {
            async let normalFeed = try bcFirestoreService.fetchLatestNormalFeeds().map { Feed(feedAPIModel: $0) }
            return HomeFeedList(
                recommendFeed: try await recommendFeed,
                normalFeed: try await normalFeed
            )
        } catch {
            // 추천피드는 값이 없으면 빈 배열이 넘어옴
            // 홈에 피드가 없는 경우 error를 catch해 빈 배열을 내보냄
            if let error = error as? FirestoreServiceError, error == .lastFetch {
                return HomeFeedList(recommendFeed: try await recommendFeed, normalFeed: [])
            } else {
                throw FeedRepositoryError.fetchRecentHomeFeedList
            }
        }
    }

    func fetchMoreNormalFeed() async throws -> [Feed] {
        do {
            return try await bcFirestoreService.fetchMoreNormalFeeds().map { Feed(feedAPIModel: $0)}
        } catch {
            if let error = error as? FirestoreServiceError, error == .lastFetch {
                return []
            } else {
                throw FeedRepositoryError.fetchMoreNormalFeed
            }
        }
    }

    // MARK: - Scrap 피드 불러오기
    func fetchRecentScrapFeed(userUUID: String) async throws -> [Feed] {
        do {
            return try await bcFirestoreService.fetchLatestScrapFeeds(userUUID: userUUID).map {
                Feed(feedAPIModel: $0, isScraped: true)
            }
        } catch {
            if let error = error as? FirestoreServiceError, error == .scrapIsEmpty {
                return []
            } else {
                throw FeedRepositoryError.fetchRecentScrapFeed
            }
        }
    }

    func fetchMoreScrapFeed(userUUID: String) async throws -> [Feed] {
        do {
            return try await bcFirestoreService.fetchMoreScrapFeeds(userUUID: userUUID).map {
                Feed(feedAPIModel: $0, isScraped: true)
            }
        } catch {
            if let error = error as? FirestoreServiceError, error == .lastFetch {
                return []
            } else {
                throw FeedRepositoryError.fetchMoreScrapFeed
            }
        }
    }

    // MARK: 피드 스크랩
    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        let scrapedFeed = feed.getScrapFeed()
        try await bcFirestoreService.scrapFeed(scrapedFeed.toScrapFeedAPIModel(), with: userUUID)
        return scrapedFeed
    }

    func unScrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        let unScrapedFeed = feed.getUnScrapFeed()
        try await bcFirestoreService.unScrapFeed(unScrapedFeed.toFeedAPIModel(), with: userUUID)
        return unScrapedFeed
    }

    // MARK: - 목업 추천 피드
    func createMockUpRecommendFeedList(count: Int) -> [Feed] {
        return feedMockUpDataSource.createMockUpRecommendFeedList(count: count)
    }
}
