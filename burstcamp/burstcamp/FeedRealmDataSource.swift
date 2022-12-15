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
                self.normalFeedListSubject.send(
                    realmModel
                        .sorted(by: \.pubDate, ascending: false)
                        .map { Feed(realmModel: $0) }
                )
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
    private let container = try! Container(debug: false, initialize: false, queue: RealmConfig.serialQueue)

    private let normalFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private let recommendFeedListSubject = CurrentValueSubject<[Feed], Error>([])
    private let scrapFeedListSubject = CurrentValueSubject<[Feed], Error>([])

    private lazy var normalRealmPublisher = container.collectionPublisher(NormalFeedRealmModel.self)
    private lazy var recommendRealmPublisher = container.collectionPublisher(RecommendFeedRealmModel.self)
    private lazy var scrapRealmPublisher = container.collectionPublisher(ScrapFeedRealmModel.self)

    // MARK: Normal FeedList

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return normalFeedListSubject
            .eraseToAnyPublisher()
    }

    func cachedNormalFeedList() -> [Feed] {
        return container.values(NormalFeedRealmModel.self)
            .sorted(by: \.pubDate, ascending: false)
            .map { Feed(realmModel: $0) }
    }

    func updateNormalFeedListCache(_ feedList: [Feed]) {
        container.serialQueue.async {
            self.container.write { transaction in
                feedList.forEach { feed in
                    let realmModel = NormalFeedRealmModel()
                    realmModel.configure(model: feed)
                    transaction.add(realmModel)
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

    func updateNormalFeed(modifiedFeed: Feed) {
//        container.serialQueue.async {
            self.container.write { transaction in
                let realmModel = NormalFeedRealmModel()
                realmModel.configure(model: modifiedFeed)
                transaction.add(realmModel, update: .modified)
            }
//        }
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
//        RealmConfig.serialQueue.async {
            self.container.write { transaction in
                feedList.forEach { feed in
                    let realmModel = RecommendFeedRealmModel()
                    realmModel.configure(model: feed)
                    transaction.add(realmModel)
                }
            }
//        }
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
        return container.values(ScrapFeedRealmModel.self)
            .sorted(by: \.scrapDate, ascending: false)
            .map { Feed(realmModel: $0) }
    }

    @available(*, deprecated, message: "대신 updateScrapFeed()를 사용해주세요")
    func updateScrapFeedListCache(_ feedList: [Feed]) {
        let diff = feedList.difference(from: cachedScrapFeedList())
        print(diff)
//        RealmConfig.serialQueue.async {
            self.container.write { transaction in
                diff.forEach { change in
                    switch change {
                    case let .remove(_, newFeed, _):
                        guard let oldRealmModel = self.container.values(ScrapFeedRealmModel.self)
                            .first(where: { feed in
                                newFeed.feedUUID == feed.feedUUID
                            })
                        else { return }
                        transaction.delete(oldRealmModel)
                    case let .insert(_, feed, _):
                        let realmModel = ScrapFeedRealmModel()
                        realmModel.configure(model: feed)
                        transaction.add(realmModel, update: .modified)
                    }
                }
//            }
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

    func updateScrapFeed(modifiedFeed: Feed) {
        if modifiedFeed.isScraped {
            let realmModel = ScrapFeedRealmModel()
            realmModel.configure(model: modifiedFeed)
            container.write { transaction in
                transaction.add(realmModel, update: .modified)
            }
        } else {
            if let oldRealmModel = container.values(ScrapFeedRealmModel.self).first(where: { oldFeed in
                oldFeed.feedUUID == modifiedFeed.feedUUID
            }) {
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
