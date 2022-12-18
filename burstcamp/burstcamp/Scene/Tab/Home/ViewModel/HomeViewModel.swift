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

    private let localDataSource: FeedLocalDataSource
    private let remoteDataSource: FeedRemoteDataSource

    init(
        localDataSource: FeedLocalDataSource = FeedRealmDataSource.shared,
        remoteDataSource: FeedRemoteDataSource = FeedRemoteDataSource.shared
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    private let reloadData = CurrentValueSubject<Void?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let hideIndicator: AnyPublisher<Void, Never>
        let showAlert: AnyPublisher<Error, Never>
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .receive(on: RealmConfig.serialQueue)
            .sink { _ in
                let userUUID = UserManager.shared.user.userUUID
                let fetcher = Fetcher<HomeFeedList, Error>(
                    onRemoteCombine: {
                        return self.remoteDataSource.recommendFeedListPublisher(userUUID: userUUID)
                            .zip(self.remoteDataSource.normalFeedListPublisher(userUUID: userUUID)) {
                                HomeFeedList(recommendFeed: $0, normalFeed: $1)
                            }
                            .eraseToAnyPublisher()
                    },
                    onLocalCombine: {
                        return self.localDataSource.recommendFeedListPublisher()
                            .zip(self.localDataSource.normalFeedListPublisher()) {
                                HomeFeedList(recommendFeed: $0, normalFeed: $1)
                            }
                            .eraseToAnyPublisher()
                    },
                    onLocal: {
                        return HomeFeedList(
                            recommendFeed: self.localDataSource.cachedRecommendFeedList(),
                            normalFeed: self.localDataSource.cachedNormalFeedList()
                        )
                    },
                    onUpdateLocal: { homeFeedList in
                        self.localDataSource.updateRecommendFeedListCache(homeFeedList.recommendFeed)
                        self.localDataSource.updateNormalFeedListCache(homeFeedList.normalFeed)
                    },
                    queue: RealmConfig.serialQueue
                )

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
    }

    func dequeueCellViewModel(at index: Int) -> ScrapViewModel {
        let scrapViewModel = ScrapViewModel(
            feedUUID: normalFeedData[index].feedUUID,
            feedLocalDataSource: FeedRealmDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
        return scrapViewModel
    }
}
