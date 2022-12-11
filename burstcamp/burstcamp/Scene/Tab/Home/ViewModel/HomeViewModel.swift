//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import BCFetcher

private struct HomeFeedList: Equatable {
    let recommendFeed: [Feed]
    let normalFeed: [Feed]
}

final class HomeViewModel {

    var recommendFeedData: [Feed] = []
    var normalFeedData: [Feed] = []

    private var cancelBag = Set<AnyCancellable>()

    private let remoteDataSource: FeedRemoteDataSource
    private let localDataSource: FeedLocalDataSource

    init(
        localDataSource: FeedLocalDataSource = FeedLocalDataSource.shared,
        remoteDataSource: FeedRemoteDataSource = FeedRemoteDataSource.shared
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    private let reloadData = CurrentValueSubject<Void?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<FirestoreServiceError?, Never>(nil)

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct Output {
        var reloadData: AnyPublisher<Void, Never>
        var hideIndicator: AnyPublisher<Void, Never>
        var showAlert: AnyPublisher<FirestoreServiceError, Never>
    }

    func transform(input: Input) -> Output {
        let fetcher = Fetcher<HomeFeedList, FirestoreServiceError>(
            onRemoteCombine: self.remoteDataSource.recommendFeedListPublisher()
                .zip(self.remoteDataSource.normalFeedListPublisher()) {
                    HomeFeedList(recommendFeed: $0, normalFeed: $1)
                }
                .eraseToAnyPublisher(),
            onLocalCombine: self.localDataSource.recommendFeedListPublisher()
                .zip(self.localDataSource.normalFeedListPublisher()) {
                    HomeFeedList(recommendFeed: $0, normalFeed: $1)
                }
                .eraseToAnyPublisher(),
            onLocal: HomeFeedList(
                recommendFeed: self.localDataSource.cachedRecommendFeedList(),
                normalFeed: self.localDataSource.cachedNormalFeedList()
            ),
            onUpdateLocal: { homeFeedList in
                self.localDataSource.updateRecommendFeedListCache(homeFeedList.recommendFeed)
                self.localDataSource.updateNormalFeedListCache(homeFeedList.normalFeed)
            }
        )

        input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .sink { _ in
                fetcher.fetch { status, data in
                    switch status {
                    case .loading:
                        self.reloadData.send(Void())
                    case .success:
                        self.hideIndicator.send(Void())
                        self.reloadData.send(Void())
                    case .failure(let error):
                        self.hideIndicator.send(Void())
                        self.showAlert.send(error)
//                    case .alreadyLatest:
//                        self.hideIndicator.send(Void())
//                        return
                    }

                    self.recommendFeedData = data.recommendFeed
                    self.normalFeedData = data.normalFeed
                }
                .store(in: &self.cancelBag)
            }
            .store(in: &cancelBag)

        return Output(
            reloadData: reloadData.unwrap().eraseToAnyPublisher(),
            hideIndicator: hideIndicator.unwrap().eraseToAnyPublisher(),
            showAlert: showAlert.unwrap().eraseToAnyPublisher()
        )
//
//        input.viewDidLoad
//            .sink { [weak self] _ in
//                self?.fetchAllFeed(output: output)
//            }
//            .store(in: &cancelBag)
//
//        input.viewRefresh
//            .sink { [weak self] _ in
//                self?.fetchAllFeed(output: output)
//            }
//            .store(in: &cancelBag)
//
//        input.pagination
//            .sink { [weak self] _ in
//                self?.paginateFeed(output: output)
//            }
//            .store(in: &cancelBag)
//
//        return output
    }

    func dequeueCellViewModel(at index: Int) -> FeedScrapViewModel {
        let firestoreFeedService = BeforeDefaultFirestoreFeedService()
        let feedScrapViewModel = FeedScrapViewModel(
            feedUUID: normalFeedData[index].feedUUID,
            feedLocalDataSource: FeedLocalDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
//        feedScrapViewModel.getScrapCountUp
//            .sink { [weak self] state in
//                guard let self = self else { return }
//                if state {
//                    self.normalFeedData[index].scrapCountUp()
//                } else {
//                    self.normalFeedData[index].scrapCountDown()
//                }
//                let indexPath = IndexPath(row: index, section: FeedCellType.normal.index)
//                self.cellUpdate.send(indexPath)
//            }
//            .store(in: &cancelBag)

        return feedScrapViewModel
    }
//
//    private func fetchAllFeed(output: Output) {
//        Task {
//            do {
//                guard !isFetching else { return }
//                isFetching = true
//                canFetchMoreFeed = true
//
//                async let recommendFeeds = fetchRecommendFeeds()
//                async let normalFeeds = fetchLastestFeeds()
//                self.recommendFeedData = try await recommendFeeds
//                self.normalFeedData = try await normalFeeds
//                output.fetchResult.send(.fetchSuccess)
//            } catch {
//                canFetchMoreFeed = false
//                debugPrint(error.localizedDescription)
//            }
//            isFetching = false
//        }
//    }
//
//    private func paginateFeed(output: Output) {
//        Task {
//            do {
//                guard !isFetching, canFetchMoreFeed else { return }
//                isFetching = true
//
//                let normalFeeds = try await fetchMoreFeeds()
//                self.normalFeedData.append(contentsOf: normalFeeds)
//                output.fetchResult.send(.fetchSuccess)
//            } catch {
//                canFetchMoreFeed = false
//                print(error.localizedDescription)
//            }
//            isFetching = false
//        }
//    }
//
//    private func fetchRecommendFeeds() async throws -> [Feed] {
//        try await withThrowingTaskGroup(of: Feed.self, body: { taskGroup in
//            var recommendFeeds: [Feed] = []
//            let feedAPIModelDictionary = try await self.firestoreService.fetchRecommendFeedAPIModels()
//
//            for feedAPIModel in feedAPIModelDictionary {
//                taskGroup.addTask {
//                    let feedAPIModel = FeedAPIModel(data: feedAPIModel)
//                    let feedWriterDictionary = try await self.firestoreFeedService.fetchUser(
//                        userUUID: feedAPIModel.writerUUID
//                    )
//                    let feedWriter = FeedWriter(data: feedWriterDictionary)
//                    let feed = Feed(feedAPIModel: feedAPIModel, feedWriter: feedWriter)
//                    return feed
//                }
//            }
//
//            for try await feed in taskGroup {
//                recommendFeeds.append(feed)
//            }
//
//            return recommendFeeds
//        })
//    }
//
//    private func fetchLastestFeeds() async throws -> [Feed] {
//        try await withThrowingTaskGroup(of: Feed.self, body: { taskGroup in
//            var normalFeeds: [Feed] = []
//            let feedAPIModelDictionary = try await self.firestoreService.fetchLatestFeedAPIModels()
//
//            for feedAPIModel in feedAPIModelDictionary {
//                taskGroup.addTask {
//                    let feedAPIModel = FeedAPIModel(data: feedAPIModel)
//                    let feedWriterDictionary = try await self.firestoreService.fetchUser(
//                        userUUID: feedAPIModel.writerUUID
//                    )
//                    let feedWriter = FeedWriter(data: feedWriterDictionary)
//                    let scrapCount = try await self.firestoreService.countFeedScarp(
//                        feedUUID: feedAPIModel.feedUUID
//                    )
//                    let feed = Feed(
//                        feedAPIModel: feedAPIModel,
//                        feedWriter: feedWriter,
//                        scrapCount: scrapCount
//                    )
//                    return feed
//                }
//            }
//
//            for try await feed in taskGroup {
//                normalFeeds.append(feed)
//            }
//
//            let result = normalFeeds.sorted { $0.pubDate > $1.pubDate }
//
//            return result
//        })
//    }
//
//    private func fetchMoreFeeds() async throws -> [Feed] {
//        try await withThrowingTaskGroup(of: Feed.self, body: { taskGroup in
//            var normalFeeds: [Feed] = []
//            let feedAPIModelDictionary = try await self.firestoreFeedService.fetchMoreFeeds()
//
//            for feedAPIModel in feedAPIModelDictionary {
//                taskGroup.addTask {
//                    let feedAPIModel = FeedAPIModel(data: feedAPIModel)
//                    print(feedAPIModel.writerUUID)
//                    let feedWriterDictionary = try await self.firestoreFeedService.fetchUser(
//                        userUUID: feedAPIModel.writerUUID
//                    )
//                    let feedWriter = FeedWriter(data: feedWriterDictionary)
//                    let scrapCount = try await self.firestoreFeedService.countFeedScarp(
//                        feedUUID: feedAPIModel.feedUUID
//                    )
//                    let feed = Feed(
//                        feedAPIModel: feedAPIModel,
//                        feedWriter: feedWriter,
//                        scrapCount: scrapCount
//                    )
//                    return feed
//                }
//            }
//
//            for try await feed in taskGroup {
//                normalFeeds.append(feed)
//            }
//
//            let result = normalFeeds.sorted { $0.pubDate > $1.pubDate }
//
//            return result
//        })
//    }
}
