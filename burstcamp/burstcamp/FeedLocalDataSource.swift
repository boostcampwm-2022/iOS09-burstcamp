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

    func toggleScrapFeed(feedUUID: String)

    func updateScrapFeedList(changedFeed feed: Feed)
    func updateFeed(feedUUID: String, _ update: (Feed) -> Feed)
}

extension FeedLocalDataSource {
    func toggleScrapFeed(feedUUID: String) {
        updateFeed(feedUUID: feedUUID) { feed in
            var newFeed = feed
            newFeed.toggleScrap()
            updateScrapFeedList(changedFeed: newFeed)
            return newFeed
        }
    }

    func updateScrapFeedList(changedFeed feed: Feed) {
        var newFeedList = cachedScrapFeedList()

        if feed.isScraped {
            // 방금 스크랩이 됐다면, 리스트에도 추가한다.
            newFeedList.append(feed)
        } else {
            // 방금 스크랩이 해제 됐다면, 리스트에서 제거한다.
            newFeedList.removeAll { $0.feedUUID == feed.feedUUID }
        }

        // 모아보기 리스트를 갱신한다.
        updateScrapFeedListCache(newFeedList)
    }

    func updateFeed(feedUUID: String, _ update: (Feed) -> Feed) {
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
        if updateNormalFeed { updateNormalFeedListCache(newNormalFeedList) }
    }
}
