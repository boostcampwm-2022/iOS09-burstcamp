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

    private var cancelBag = Set<AnyCancellable>()

    // swiftlint:disable:next force_try
    private let container = try! Container(debug: false, initialize: false, queue: RealmConfig.serialQueue)

    private lazy var normalRealmPublisher = container.collectionPublisher(NormalFeedRealmModel.self)
    private lazy var recommendRealmPublisher = container.collectionPublisher(RecommendFeedRealmModel.self)
    private lazy var scrapRealmPublisher = container.collectionPublisher(ScrapFeedRealmModel.self)

    private let normalSortingPolicy: SortingPolicy<NormalFeedRealmModel, Date> = (\.pubDate, ascending: false)
    private let recommendSortingPolicy: SortingPolicy<RecommendFeedRealmModel, Date> = (\.pubDate, ascending: false)
    private let scrapSortingPolicy: SortingPolicy<ScrapFeedRealmModel, Date?> = (\.scrapDate, ascending: false)

    private let normalFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private let recommendFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private let scrapFeedListSubject = CurrentValueSubject<[Feed], Error>([])

    func configure() {
        normalRealmPublisher
            .sink { response in
                self.normalFeedListSubject.send(completion: response)
            } receiveValue: { [normalSortingPolicy] realmModel in
                self.normalFeedListSubject.send(
                    realmModel
                        .sorted(using: normalSortingPolicy)
                        .map { Feed(realmModel: $0) }
                )
            }
            .store(in: &cancelBag)

        recommendRealmPublisher
            .sink { response in
                self.recommendFeedListSubject.send(completion: response)
            } receiveValue: { [recommendSortingPolicy] realmModel in
                self.recommendFeedListSubject.send(
                    realmModel
                        .sorted(using: recommendSortingPolicy)
                        .map { Feed(realmModel: $0) }
                )
            }
            .store(in: &cancelBag)

        scrapRealmPublisher
            .sink { response in
                self.scrapFeedListSubject.send(completion: response)
            } receiveValue: { [scrapSortingPolicy] realmModel in
                self.scrapFeedListSubject.send(
                    realmModel
                        .sorted(using: scrapSortingPolicy)
                        .map { Feed(realmModel: $0) }
                )
            }
            .store(in: &cancelBag)
    }

    // MARK: Normal FeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return normalFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedNormalFeedList() -> [Feed] {
        return container.values(NormalFeedRealmModel.self)
            .sorted(using: normalSortingPolicy)
            .map { Feed(realmModel: $0) }
    }

    func updateNormalFeedListCache(_ feedList: [Feed]) {
        container.write { transaction in
            feedList.forEach { feed in
                let realmModel = NormalFeedRealmModel()
                realmModel.configure(model: feed)
                transaction.add(realmModel)
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

    func updateNormalFeed(modifiedFeed: Feed) {
        container.write { transaction in
            let realmModel = NormalFeedRealmModel()
            realmModel.configure(model: modifiedFeed)
            transaction.add(realmModel, update: .modified)
        }
    }

    // MARK: Recommend FeedList

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return recommendFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedRecommendFeedList() -> [Feed] {
        return container.values(RecommendFeedRealmModel.self)
            .map { Feed(realmModel: $0) }
    }

    func updateRecommendFeedListCache(_ feedList: [Feed]) {
        container.write { transaction in
            feedList.forEach { feed in
                let realmModel = RecommendFeedRealmModel()
                realmModel.configure(model: feed)
                transaction.add(realmModel)
            }
        }
    }

    // MARK: Scrap FeedList

    func scrapFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return scrapFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedScrapFeedList() -> [Feed] {
        return container.values(ScrapFeedRealmModel.self)
            .sorted(using: scrapSortingPolicy)
            .map { Feed(realmModel: $0) }
    }

    func updateScrapFeedListCache(_ feedList: [Feed]) {
        let diff = feedList.difference(from: cachedScrapFeedList())
        container.write { transaction in
            diff.forEach { change in
                switch change {
                case let .remove(_, oldFeed, _):
                    if let oldRealmModel = self.cachedScrapFeedRealmModel(feedUUID: oldFeed.feedUUID) {
                        transaction.delete(oldRealmModel)
                    }
                case let .insert(_, newFeed, _):
                    let realmModel = ScrapFeedRealmModel()
                    realmModel.configure(model: newFeed)
                    transaction.add(realmModel, update: .modified)
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

    func cachedScrapFeedRealmModel(feedUUID: String) -> ScrapFeedRealmModel? {
        return container.values(ScrapFeedRealmModel.self).first(where: { realmModel in
            realmModel.feedUUID == feedUUID
        })
    }

    func updateScrapFeed(modifiedFeed: Feed) {
        if modifiedFeed.isScraped {
            let realmModel = ScrapFeedRealmModel()
            realmModel.configure(model: modifiedFeed)
            container.write { transaction in
                transaction.add(realmModel, update: .modified)
            }
        } else {
            if let oldRealmModel = cachedScrapFeedRealmModel(feedUUID: modifiedFeed.feedUUID) {
                container.write { transaction in
                    transaction.delete(oldRealmModel)
                }
            }
        }
    }
}

extension FeedRealmDataSource {
    /// 스크랩 상태가 변경된 feed가 들어옴
    func toggleScrapFeed(modifiedFeed: Feed) {
        // Normal Feed의 isScrap, scrapDate 상태 반영
        updateNormalFeed(modifiedFeed: modifiedFeed)
        // ScrapFeedList의 Diff를 반영
        updateScrapFeed(modifiedFeed: modifiedFeed)
    }
}
