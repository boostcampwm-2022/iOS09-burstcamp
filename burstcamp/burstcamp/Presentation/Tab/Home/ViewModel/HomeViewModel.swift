//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import BCFetcher

struct HomeFeedList: Equatable {
    let recommendFeed: [Feed]
    let normalFeed: [Feed]
}

final class HomeViewModel {

    var recommendFeedData: [Feed] = []
    var normalFeedData: [Feed] = []

    private var cancelBag = Set<AnyCancellable>()

    private let homeUseCase: HomeUseCase
    private let localDataSource: FeedLocalDataSource
    private let remoteDataSource: FeedRemoteDataSource

    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        self.localDataSource = FeedRealmDataSource.shared
        self.remoteDataSource = FeedRemoteDataSource.shared
    }

    private let recentFeed = CurrentValueSubject<HomeFeedList?, Never>(nil)
    private let moreFeed = CurrentValueSubject<[Feed]?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct Output {
        let recentFeed: AnyPublisher<HomeFeedList, Never>
        let moreFeed: AnyPublisher<[Feed], Never>
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
                        self.localDataSource.updateRecommendFeedListOnCache(homeFeedList.recommendFeed)
                        self.localDataSource.updateNormalFeedListOnCache(homeFeedList.normalFeed)
                    },
                    queue: RealmConfig.serialQueue
                )

                fetcher.fetch { status, data in
                    switch status {
                    case .loading:
                        self.recentFeed.send(data)
                    case .success:
                        self.hideIndicator.send(Void())
                        self.recentFeed.send(data)
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
            recentFeed: recentFeed.unwrap().eraseToAnyPublisher(),
            moreFeed: moreFeed.unwrap().eraseToAnyPublisher(),
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
