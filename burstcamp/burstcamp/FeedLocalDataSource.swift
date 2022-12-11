//
//  FeedLocalDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import Combine
import Foundation

final class FeedLocalDataSource {

    typealias Failure = FirestoreServiceError

    static let shared = FeedLocalDataSource()
    private init () { }

    private var normalFeedListSubject = CurrentValueSubject<[Feed], Failure>([])
    private var recommendFeedListSubject = CurrentValueSubject<[Feed], Failure>([])

    private lazy var sharedNormalFeedListPublisher
    : AnyPublisher<[Feed], Failure> = normalFeedListSubject
        .share()
        .eraseToAnyPublisher()

    private lazy var sharedRecommendFeedListPublisher
    : AnyPublisher<[Feed], Failure> = recommendFeedListSubject
        .share()
        .eraseToAnyPublisher()
}

extension FeedLocalDataSource {
    // MARK: Normal FeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return sharedNormalFeedListPublisher
    }

    func cachedNormalFeedList() -> [Feed] {
        return normalFeedListSubject.value
    }

    func updateNormalFeedListCache(_ feedList: [Feed]) {
        normalFeedListSubject.send(feedList)
    }

    // MARK: Normal Feed
    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return sharedNormalFeedListPublisher
            .compactMap { $0.first { $0.feedUUID == feedUUID } }
            .eraseToAnyPublisher()
    }

    func cachedNormalFeed(feedUUID: String) -> Feed {
        guard let feed = normalFeedListSubject.value
            .first(where: { $0.feedUUID == feedUUID })
        else {
            fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요")
        }
        return feed
    }

    // MARK: Recommend FeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return sharedRecommendFeedListPublisher
    }

    func cachedRecommendFeedList() -> [Feed] {
        return normalFeedListSubject.value
    }

    func updateRecommendFeedListCache(_ feedList: [Feed]) {
        recommendFeedListSubject.send(feedList)
    }
}

extension FeedLocalDataSource {
    func toggleScrapFeed(feedUUID: String) {
        updateFeed(feedUUID: feedUUID) { feed in
            var newFeed = feed
            newFeed.toggleScrap()
            return newFeed
        }
    }

    func scrapFeed(feedUUID: String) {
        updateFeed(feedUUID: feedUUID) { feed in
            var newFeed = feed
            newFeed.scrap()
            return newFeed
        }
    }

    func unScrapFeed(feedUUID: String) {
        updateFeed(feedUUID: feedUUID) { feed in
            var newFeed = feed
            newFeed.unScrap()
            return newFeed
        }
    }

    func updateFeed(feedUUID: String, _ update: (Feed) -> Feed) {
        let newFeedList = cachedNormalFeedList()
            .map { feed in
                if feed.feedUUID == feedUUID {
                    return update(feed)
                } else {
                    return feed
                }
            }
        updateNormalFeedListCache(newFeedList)
    }
}
