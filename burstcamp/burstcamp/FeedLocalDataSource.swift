//
//  FeedLocalDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/14.
//

import Combine
import Foundation

enum RealmConfig {
    static let serialQueue = DispatchQueue(label: "RealmQueue")
//    static let serialQueue = DispatchQueue.main
}

protocol FeedLocalDataSource {

    // MARK: NormalFeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Error>
    func cachedNormalFeedList() -> [Feed]
    func updateNormalFeedListCache(_ feedList: [Feed])

    // MARK: NormalFeed

    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error>
    func cachedNormalFeed(feedUUID: String) -> Feed

    // MARK: RecommendFeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Error>
    func cachedRecommendFeedList() -> [Feed]
    func updateRecommendFeedListCache(_ feedList: [Feed])

    // MARK: RecommendFeed

    func recommendFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error>
    func cachedRecommendFeed(feedUUID: String) -> Feed

    // MARK: ScrapFeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Error>
    func cachedScrapFeedList() -> [Feed]
    func updateScrapFeedListCache(_ feedList: [Feed])

    // MARK: ScrapFeed

    func scrapFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error>
    func cachedScrapFeed(feedUUID: String) -> Feed

    // MARK: Scrap 기능

    func toggleScrapFeed(modifiedFeed: Feed)
}
