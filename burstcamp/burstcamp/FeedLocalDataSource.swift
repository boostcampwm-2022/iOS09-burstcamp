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
    private var scrapFeedListSubject = CurrentValueSubject<[Feed], Failure>([])

    private lazy var sharedNormalFeedListPublisher
    : AnyPublisher<[Feed], Failure> = normalFeedListSubject
        .eraseToAnyPublisher()

    private lazy var sharedRecommendFeedListPublisher
    : AnyPublisher<[Feed], Failure> = recommendFeedListSubject
        .eraseToAnyPublisher()

    private lazy var sharedScrapFeedListPublisher
    : AnyPublisher<[Feed], Failure> = scrapFeedListSubject
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

    func updateNormalFeedListOnCache(_ feedList: [Feed]) {
        normalFeedListSubject.send(feedList)
    }

    // MARK: Normal Feed
    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return sharedNormalFeedListPublisher
            .compactMap { $0.feed(feedUUID: feedUUID) }
            .eraseToAnyPublisher()
    }

    func cachedNormalFeed(feedUUID: String) -> Feed {
        guard let feed = normalFeedListSubject.value.feed(feedUUID: feedUUID)
        else { fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요") }
        return feed
    }

    // MARK: Recommend FeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return sharedRecommendFeedListPublisher
    }

    func cachedRecommendFeedList() -> [Feed] {
        return normalFeedListSubject.value
    }

    func updateRecommendFeedListOnCache(_ feedList: [Feed]) {
        recommendFeedListSubject.send(feedList)
    }

    // MARK: Recommend Feed

    func recommendFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return sharedRecommendFeedListPublisher
            .compactMap { $0.feed(feedUUID: feedUUID) }
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeed(feedUUID: String) -> Feed {
        guard let feed = recommendFeedListSubject.value.feed(feedUUID: feedUUID)
        else { fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요") }
        return feed
    }

    // MARK: Scrap FeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return sharedScrapFeedListPublisher
    }

    func cachedScrapFeedList() -> [Feed] {
        return scrapFeedListSubject.value
    }

    func updateScrapFeedListOnCache(_ feedList: [Feed]) {
        scrapFeedListSubject.send(feedList)
    }

    // MARK: Scrap Feed

    func scrapFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return sharedScrapFeedListPublisher
            .compactMap { $0.feed(feedUUID: feedUUID) }
            .eraseToAnyPublisher()
    }

    func cachedScrapFeed(feedUUID: String) -> Feed {
        guard let feed = scrapFeedListSubject.value.feed(feedUUID: feedUUID)
        else { fatalError("존재하지 않는 피드에 접근했습니다. 다시 시도해주세요") }
        return feed
    }
}

// MARK: Scrap기능

extension FeedLocalDataSource {
    func toggleScrapFeed(feedUUID: String) {
        updateFeed(feedUUID: feedUUID) { feed in
            var newFeed = feed
            newFeed.toggleScrap()
            updateScrapFeedList(changedFeed: newFeed)
            return newFeed
        }
    }

    private func updateScrapFeedList(changedFeed feed: Feed) {
        var newFeedList = cachedScrapFeedList()

        if feed.isScraped {
            // 방금 스크랩이 됐다면, 리스트에도 추가한다.
            newFeedList.append(feed)
        } else {
            // 방금 스크랩이 해제 됐다면, 리스트에서 제거한다.
            if let removeIndex = newFeedList.firstIndex(where: { $0.feedUUID == feed.feedUUID }) {
                newFeedList.remove(at: removeIndex)
            }
        }

        // 모아보기 리스트를 갱신한다.
        updateScrapFeedListOnCache(newFeedList)
    }

    private func updateFeed(feedUUID: String, _ update: (Feed) -> Feed) {
        // 업데이트할 피드가 normal에 있다면, `update`로직을 수행한 뒤, 목록도 업데이트한다.
        var updateNormalFeed = false
        let newNormalFeedList = cachedNormalFeedList()
            .map { feed in
                if feed.feedUUID == feedUUID {
                    updateNormalFeed = true
                    return update(feed)
                } else {
                    return feed
                }
            }
        if updateNormalFeed { updateNormalFeedListOnCache(newNormalFeedList) }
    }
}

extension Collection where Element == Feed {
    func feed(feedUUID: String) -> Feed? {
        self.first { $0.feedUUID == feedUUID }
    }
}
