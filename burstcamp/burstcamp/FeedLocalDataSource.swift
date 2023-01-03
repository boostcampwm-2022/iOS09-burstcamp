//
//  FeedLocalDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/14.
//

import Combine
import Foundation

protocol FeedLocalDataSource {

    // MARK: NormalFeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Error>
    func cachedNormalFeedList() -> [Feed]
    func updateNormalFeedListOnCache(_ feedList: [Feed])

    // MARK: NormalFeed

    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error>
    func cachedNormalFeed(feedUUID: String) -> Feed

    // MARK: RecommendFeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Error>
    func cachedRecommendFeedList() -> [Feed]
    func updateRecommendFeedListOnCache(_ feedList: [Feed])

    // MARK: ScrapFeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Error>
    func cachedScrapFeedList() -> [Feed]
    func updateScrapFeedListOnCache(_ feedList: [Feed])

    // MARK: ScrapFeed

    func scrapFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error>

    // MARK: Scrap 기능

    func toggleScrapFeed(modifiedFeed: Feed)
}
