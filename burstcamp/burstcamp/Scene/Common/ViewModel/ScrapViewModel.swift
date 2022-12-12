//
//  ScrapViewModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/05.
//

import Combine
import Foundation

import BCFetcher

final class ScrapViewModel {

    private var cancelBag = Set<AnyCancellable>()

    private let feedUUID: String
    private let userUUID: String

    private let feedLocalDataSource: FeedLocalDataSource
    private let feedRemoteDataSource: FeedRemoteDataSource

    private let scrapButtonState = CurrentValueSubject<Bool?, Never>(nil)
    private let scrapButtonCount = CurrentValueSubject<String?, Never>(nil)
    private let scrapButtonIsEnabled = CurrentValueSubject<Bool?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

    private lazy var updater = Updater<Feed, FirestoreServiceError>(
        onRemoteCombine: {
            self.feedRemoteDataSource.updateFeedPublisher(
                feedUUID: self.feedUUID,
                userUUID: self.userUUID,
                feed: $0
            )
        },
        onLocalCombine: self.feedLocalDataSource.normalFeedPublisher(feedUUID: self.feedUUID),
        onLocal: self.feedLocalDataSource.cachedNormalFeed(feedUUID: self.feedUUID),
        onUpdateLocal: self.feedLocalDataSource.toggleScrapFeed(feedUUID: self.feedUUID)
    )

    init(
        feedUUID: String,
        feedLocalDataSource: FeedLocalDataSource,
        feedRemoteDataSource: FeedRemoteDataSource
    ) {
        self.feedUUID = feedUUID
        self.userUUID = UserManager.shared.user.userUUID
        self.feedLocalDataSource = feedLocalDataSource
        self.feedRemoteDataSource = feedRemoteDataSource
    }

    struct Input {
        let scrapToggleButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let scrapButtonState: AnyPublisher<Bool, Never>
        let scrapButtonCount: AnyPublisher<String, Never>
        let scrapButtonIsEnabled: AnyPublisher<Bool, Never>
        let showAlert: AnyPublisher<Error, Never>
    }

    func transform(input: Input) -> Output {
        updater.configure { status, data in
            switch status {
            case .loading:
                self.scrapButtonIsEnabled.send(false)
            case .success:
                self.scrapButtonState.send(data.isScraped)
                self.scrapButtonCount.send("\(data.scrapCount)")
                self.scrapButtonIsEnabled.send(true)
            case .failure(let error):
                self.showAlert.send(error)
                self.scrapButtonIsEnabled.send(true)
            }
        }
        .store(in: &self.cancelBag)

        input.scrapToggleButtonDidTap
            .sink { _ in
                self.updater.update()
            }
            .store(in: &cancelBag)

        return Output(
            scrapButtonState: scrapButtonState.unwrap().eraseToAnyPublisher(),
            scrapButtonCount: scrapButtonCount.unwrap().eraseToAnyPublisher(),
            scrapButtonIsEnabled: scrapButtonIsEnabled.unwrap().eraseToAnyPublisher(),
            showAlert: showAlert.unwrap().eraseToAnyPublisher()
        )
    }
}
