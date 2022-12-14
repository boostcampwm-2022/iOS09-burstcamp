//
//  FeedSingletonDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import Combine
import Foundation

/// Realm 없이 로컬에서 테스트 하기 위한 Datasource
///
final class FeedSingletonDataSource: FeedLocalDataSource {

    static let shared = FeedSingletonDataSource()
    private init () { }

    private var normalFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private var recommendFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private var scrapFeedListSubject = CurrentValueSubject<[Feed], Error>([])
}

extension FeedSingletonDataSource {
    // MARK: Normal FeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Error> {
        return normalFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedNormalFeedList() -> [Feed] {
        return normalFeedListSubject.value
    }

    func updateNormalFeedListCache(_ feedList: [Feed]) {
        normalFeedListSubject.send(feedList)
    }

    // MARK: Normal Feed
    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error> {
        return normalFeedListSubject
            .compactMap { $0.feed(feedUUID: feedUUID) }
            .eraseToAnyPublisher()
    }

    func cachedNormalFeed(feedUUID: String) -> Feed {
        guard let feed = normalFeedListSubject.value.feed(feedUUID: feedUUID)
        else { fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요") }
        return feed
    }

    // MARK: Recommend FeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Error> {
        return recommendFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeedList() -> [Feed] {
        return recommendFeedListSubject.value
    }

    func updateRecommendFeedListCache(_ feedList: [Feed]) {
        recommendFeedListSubject.send(feedList)
    }

    // MARK: Recommend Feed

    func recommendFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error> {
        return recommendFeedListSubject
            .compactMap { $0.feed(feedUUID: feedUUID) }
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeed(feedUUID: String) -> Feed {
        guard let feed = recommendFeedListSubject.value.feed(feedUUID: feedUUID)
        else { fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요") }
        return feed
    }

    // MARK: Scrap FeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Error> {
        return scrapFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedScrapFeedList() -> [Feed] {
        return scrapFeedListSubject.value
    }

    func updateScrapFeedListCache(_ feedList: [Feed]) {
        scrapFeedListSubject.send(feedList)
    }

    // MARK: Scrap Feed

    func scrapFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Error> {
        return scrapFeedListSubject
            .compactMap { $0.feed(feedUUID: feedUUID) }
            .eraseToAnyPublisher()
    }

    func cachedScrapFeed(feedUUID: String) -> Feed {
        guard let feed = scrapFeedListSubject.value.feed(feedUUID: feedUUID)
        else { fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요") }
        return feed
    }
}

extension Collection where Element == Feed {
    func feed(feedUUID: String) -> Feed? {
        self.first { $0.feedUUID == feedUUID }
    }
}
