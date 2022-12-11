//
//  FeedScrapViewModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/05.
//

import Combine
import Foundation

import BCFetcher

enum UpdateMethod {
    case append
    case remove
}

final class FeedScrapViewModel {
    private var cancelBag = Set<AnyCancellable>()

    private let feedUUID: String
    private let userUUID: String

    private let feedLocalDataSource: FeedLocalDataSource
    private let feedRemoteDataSource: FeedRemoteDataSource

    private let scrapButtonState = CurrentValueSubject<Bool?, Never>(nil)
    private let scrapButtonCount = CurrentValueSubject<String?, Never>(nil)
    private let scrapButtonIsEnabled = PassthroughSubject<Bool, Never>()
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

    init(
        feedUUID: String,
        feedLocalDataSource: FeedLocalDataSource,
        feedRemoteDataSource: FeedRemoteDataSource
    ) {
        self.feedUUID = feedUUID
        self.userUUID = UserManager.shared.user.userUUID
        self.feedLocalDataSource = feedLocalDataSource
        self.feedRemoteDataSource = feedRemoteDataSource

        feedLocalDataSource
            .normalFeedPublisher(feedUUID: feedUUID)
            .sink(receiveCompletion: { response in
                if case let .failure(error) = response {
                    self.showAlert.send(error)
                }
                self.scrapButtonIsEnabled.send(true)
            }, receiveValue: { feed in
                self.scrapButtonState.send(feed.isScraped)
                self.scrapButtonCount.send("\(feed.scrapCount)")
                self.scrapButtonIsEnabled.send(true)
            })
            .store(in: &cancelBag)
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let scrapToggleButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let scrapButtonState: AnyPublisher<Bool, Never>
        let scrapButtonCount: AnyPublisher<String, Never>
        let scrapButtonIsEnabled: AnyPublisher<Bool, Never>
        let showAlert: AnyPublisher<Error, Never>
    }

    func transform(input: Input) -> Output {
        let updater = Updater<Feed, FirestoreServiceError>(
            onRemoteCombine: {
                self.feedRemoteDataSource.updateFeedPublisher(
                    feedUUID: self.feedUUID,
                    userUUID: self.userUUID,
                    scrapState: $0.isScraped
                )
            },
            onLocalCombine: self.feedLocalDataSource.normalFeedPublisher(feedUUID: self.feedUUID),
            onLocal: self.feedLocalDataSource.cachedNormalFeed(feedUUID: self.feedUUID),
            onUpdateLocal: self.feedLocalDataSource.toggleScrapFeed(feedUUID: self.feedUUID)
        )

        input.viewDidLoad
            .sink { _ in
                updater.configure { status, data in
                    switch status {
                    case .loading:
                        self.scrapButtonIsEnabled.send(true)
                    case .success:
                        self.scrapButtonState.send(data.isScraped)
                        self.scrapButtonCount.send("\(data.scrapCount)")
                        self.scrapButtonIsEnabled.send(false)
                    case .failure(let error):
                        self.showAlert.send(error)
                        self.scrapButtonIsEnabled.send(false)
                    }
                }
                .store(in: &self.cancelBag)
            }
            .store(in: &cancelBag)

        input.scrapToggleButtonDidTap
            .throttle(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main,
                latest: false
            )
            .sink { _ in
                updater.update()
            }
            .store(in: &cancelBag)

        return Output(
            scrapButtonState: scrapButtonState.unwrap().eraseToAnyPublisher(),
            scrapButtonCount: scrapButtonCount.unwrap().eraseToAnyPublisher(),
            scrapButtonIsEnabled: scrapButtonIsEnabled.eraseToAnyPublisher(),
            showAlert: showAlert.unwrap().eraseToAnyPublisher()
        )
    }
}
