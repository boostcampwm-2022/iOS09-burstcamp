//
//  FeedRealmDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Combine
import Foundation

import RealmManager
import RealmSwift

final class FeedRealmDataSource: FeedLocalDataSource {

    typealias Failure = Error

    static let shared = FeedRealmDataSource()

    private init() { }

    func configure() {
        normalRealmPublisher
            .sink { response in
                self.normalFeedListSubject.send(completion: response)
            } receiveValue: { realmModel in
                self.normalFeedListSubject.send(realmModel.map { Feed(realmModel: $0) })
            }
            .store(in: &cancelBag)

        recommendRealmPublisher
            .sink { response in
                self.recommendFeedListSubject.send(completion: response)
            } receiveValue: { realmModel in
                print("recommend", realmModel.count)
                self.recommendFeedListSubject.send(realmModel.map { Feed(realmModel: $0) })
            }
            .store(in: &cancelBag)

        scrapRealmPublisher
            .sink { response in
                self.scrapFeedListSubject.send(completion: response)
            } receiveValue: { realmModel in
                self.scrapFeedListSubject.send(
                    realmModel
                        .sorted(by: \.scrapDate, ascending: false)
                        .map { Feed(realmModel: $0) }
                )
            }
            .store(in: &cancelBag)
    }

    private var cancelBag = Set<AnyCancellable>()

    // swiftlint:disable:next force_try
    private let container = try! Container(debug: true, initialize: false, queue: RealmConfig.serialQueue)

    private let normalFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private let recommendFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private let scrapFeedListSubject = CurrentValueSubject<[Feed], Error>([])

    private lazy var normalRealmPublisher = container.publisher(NormalFeedRealmModel.self)
    private lazy var recommendRealmPublisher = container.publisher(RecommendFeedRealmModel.self)
    private lazy var scrapRealmPublisher = container.publisher(ScrapFeedRealmModel.self)

    // MARK: Normal FeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return normalFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedNormalFeedList() -> [Feed] {
        return normalFeedListSubject.value
    }

    func updateNormalFeedListCache(_ feedList: [Feed]) {
        container.serialQueue.async {
            self.container.write { transaction in
                feedList.forEach { feed in
                    let realmModel = NormalFeedRealmModel()
                    realmModel.configure(model: feed)
                    transaction.add(realmModel, autoIncrement: true)
                }
            }
        }
    }

    // MARK: Normal Feed
    func normalFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return normalFeedListSubject
            .compactMap { $0.first { $0.feedUUID == feedUUID }}
            .eraseToAnyPublisher()
    }

    func cachedNormalFeed(feedUUID: String) -> Feed {
        guard let feed = normalFeedListSubject.value
            .first(where: { $0.feedUUID == feedUUID })
        else {
            print("존재하지 않는 피드에 접근했습니다(\(feedUUID))")
            return Feed()
        }
        return feed
    }

    // MARK: Recommend FeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return recommendFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeedList() -> [Feed] {
        return recommendFeedListSubject.value
    }

    func updateRecommendFeedListCache(_ feedList: [Feed]) {
        RealmConfig.serialQueue.async {
            self.container.write { transaction in
                feedList.forEach { feed in
                    let realmModel = RecommendFeedRealmModel()
                    realmModel.configure(model: feed)
                    transaction.add(realmModel, autoIncrement: true)
                }
            }
        }
    }

    // MARK: Recommend Feed

    func recommendFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return recommendFeedListSubject
            .compactMap { $0.first { $0.feedUUID == feedUUID }}
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeed(feedUUID: String) -> Feed {
        guard let feed = recommendFeedListSubject.value
            .first(where: { $0.feedUUID == feedUUID })
        else {
            print("존재하지 않는 피드에 접근했습니다(\(feedUUID))")
            return Feed()
        }
        return feed
    }

    // MARK: Scrap FeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return scrapFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedScrapFeedList() -> [Feed] {
        return scrapFeedListSubject.value
    }

    func updateScrapFeedListCache(_ feedList: [Feed]) {
        RealmConfig.serialQueue.async {
            self.container.write { transaction in
                feedList.forEach { feed in
                    let realmModel = ScrapFeedRealmModel()
                    realmModel.configure(model: feed)
                    transaction.add(realmModel, autoIncrement: true, update: .all)
                }
            }
        }
    }

    // MARK: Scrap Feed

    func scrapFeedPublisher(feedUUID: String) -> AnyPublisher<Feed, Failure> {
        return scrapFeedListSubject
            .compactMap { $0.first { $0.feedUUID == feedUUID }}
            .eraseToAnyPublisher()
    }

    func cachedScrapFeed(feedUUID: String) -> Feed {
        guard let feed = scrapFeedListSubject.value
            .first(where: { $0.feedUUID == feedUUID })
        else {
            print("존재하지 않는 피드에 접근했습니다(\(feedUUID))")
            return Feed()
        }
        return feed
    }
}
