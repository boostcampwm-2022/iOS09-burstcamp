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
    private let fetcher: Fetcher<HomeFeedList, FirestoreServiceError>

    init(
        localDataSource: FeedLocalDataSource = FeedLocalDataSource.shared,
        remoteDataSource: FeedRemoteDataSource = FeedRemoteDataSource.shared
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource

        let userUUID = UserManager.shared.user.userUUID
        fetcher = Fetcher<HomeFeedList, FirestoreServiceError>(
            onRemoteCombine: {
                remoteDataSource.recommendFeedListPublisher(userUUID: userUUID)
                    .zip(remoteDataSource.normalFeedListPublisher(userUUID: userUUID)) {
                        HomeFeedList(recommendFeed: $0, normalFeed: $1)
                    }
                    .eraseToAnyPublisher()
            },
            onLocalCombine: {
                localDataSource.recommendFeedListPublisher()
                    .zip(localDataSource.normalFeedListPublisher()) {
                        HomeFeedList(recommendFeed: $0, normalFeed: $1)
                    }
                    .eraseToAnyPublisher()
            },
            onLocal: {
                HomeFeedList(
                    recommendFeed: localDataSource.cachedRecommendFeedList(),
                    normalFeed: localDataSource.cachedNormalFeedList()
                )
            },
            onUpdateLocal: { homeFeedList in
                localDataSource.updateRecommendFeedListCache(homeFeedList.recommendFeed)
                localDataSource.updateNormalFeedListCache(homeFeedList.normalFeed)
            }
        )
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
        let reloadData: AnyPublisher<Void, Never>
        let hideIndicator: AnyPublisher<Void, Never>
        let showAlert: AnyPublisher<FirestoreServiceError, Never>
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .sink { _ in
                self.fetcher.fetch { status, data in
//                    print("\(#fileID) | fetcher: \(status)")
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
    }

    func dequeueCellViewModel(at index: Int) -> ScrapViewModel {
        let scrapViewModel = ScrapViewModel(
            feedUUID: normalFeedData[index].feedUUID,
            feedLocalDataSource: FeedLocalDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
        return scrapViewModel
    }
}
