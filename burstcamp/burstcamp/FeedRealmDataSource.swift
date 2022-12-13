//
//  FeedRealmDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation
import Combine

import RealmManager
import RealmSwift

final class FeedRealmDataSource {

    typealias Failure = Error

    static let shared = FeedRealmDataSource()
    private var cancelBag = Set<AnyCancellable>()

    // swiftlint:disable:next force_try
    private let container = try! Container(debug: true)

    private lazy var normalRealmPublisher = container.publisher(NormalFeedRealmModel.self)
    private lazy var recommendRealmPublisher = container.publisher(RecommendFeedRealmModel.self)
    private lazy var scrapRealmPublisher = container.publisher(ScrapFeedRealmModel.self)

    private init() { }

    // MARK: Normal FeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return normalRealmPublisher
            .map { $0.map { Feed(realmModel: $0) }}
            .eraseToAnyPublisher()
    }

    func cachedNormalFeedList() -> [Feed] {
        return container.values(NormalFeedRealmModel.self)
            .map { Feed(realmModel: $0) }
    }

    func updateNormalFeedListCache(_ feedList: [Feed]) {
        //swiftlint:disable:next force_try
        try! container.write { transaction in
            feedList.forEach { feed in
                guard let realmModel = feed.realmModel() as? NormalFeedRealmModel else {
                    print(#fileID, "NormalFeedRealmModel로 변환하지 못함(\(feed.feedUUID))")
                    return
                }
                transaction.add(realmModel, autoIncrement: true)
            }
        }
    }

    // MARK: Normal Feed
    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return normalRealmPublisher
            .compactMap { $0.first { $0.feedUUID == feedUUID }}
            .map { Feed(realmModel: $0) }
            .eraseToAnyPublisher()
    }

    func cachedNormalFeed(feedUUID: String) -> Feed {
        guard let realmModel = container.values(NormalFeedRealmModel.self)
            .first(where: { $0.feedUUID == feedUUID })
        else {
            print("존재하지 않는 피드에 접근했습니다(\(feedUUID))")
            return Feed(realmModel: FeedRealmModel())
        }
        return Feed(realmModel: realmModel)
    }

    // MARK: Recommend FeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return recommendRealmPublisher
            .map { $0.map { Feed(realmModel: $0) }}
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeedList() -> [Feed] {
        return container.values(RecommendFeedRealmModel.self)
            .map { Feed(realmModel: $0) }
    }

    func updateRecommendFeedListCache(_ feedList: [Feed]) {
        //swiftlint:disable:next force_try
        try! container.write { transaction in
            feedList.forEach { feed in
                guard let realmModel = feed.realmModel() as? RecommendFeedRealmModel else {
                    print(#fileID, "RecommendFeedRealmModel로 변환하지 못함(\(feed.feedUUID))")
                    return
                }
                transaction.add(realmModel, autoIncrement: true)
            }
        }
    }

    // MARK: Recommend Feed

    func recommendFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return recommendRealmPublisher
            .compactMap { $0.first { $0.feedUUID == feedUUID }}
            .map { Feed(realmModel: $0) }
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeed(feedUUID: String) -> Feed {
        guard let realmModel = container.values(RecommendFeedRealmModel.self)
            .first(where: { $0.feedUUID == feedUUID })
        else {
            print("존재하지 않는 피드에 접근했습니다(\(feedUUID))")
            return Feed(realmModel: FeedRealmModel())
        }
        return Feed(realmModel: realmModel)
    }

    // MARK: Scrap FeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return scrapRealmPublisher
            .map { $0.map { Feed(realmModel: $0) }}
            .eraseToAnyPublisher()
    }

    func cachedScrapFeedList() -> [Feed] {
        return container.values(ScrapFeedRealmModel.self)
            .map { Feed(realmModel: $0) }
    }

    func updateScrapFeedListCache(_ feedList: [Feed]) {
        //swiftlint:disable:next force_try
        try! container.write { transaction in
            feedList.forEach { feed in
                guard let realmModel = feed.realmModel() as? ScrapFeedRealmModel else {
                    print(#fileID, "ScrapFeedRealmModel로 변환하지 못함(\(feed.feedUUID))")
                    return
                }
                transaction.add(realmModel, autoIncrement: true)
            }
        }
    }

    // MARK: Scrap Feed

    func scrapFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return scrapRealmPublisher
            .compactMap { $0.first { $0.feedUUID == feedUUID }}
            .map { Feed(realmModel: $0) }
            .eraseToAnyPublisher()
    }

    func cachedScrapFeed(feedUUID: String) -> Feed {
        guard let realmModel = container.values(NormalFeedRealmModel.self)
            .first(where: { $0.feedUUID == feedUUID })
        else {
            print("존재하지 않는 피드에 접근했습니다(\(feedUUID))")
            return Feed(realmModel: FeedRealmModel())
        }
        return Feed(realmModel: realmModel)
    }
}
