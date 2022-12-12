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

    private let feedLocalDataSource: FeedLocalDataSource
    private let feedRemoteDataSource: FeedRemoteDataSource

    private let scrapButtonState = CurrentValueSubject<Bool?, Never>(nil)
    private let scrapButtonCount = CurrentValueSubject<String?, Never>(nil)
    private let scrapButtonIsEnabled = CurrentValueSubject<Bool?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

    private let updater: Updater<Feed, FirestoreServiceError>

    init(
        feedUUID: String,
        feedLocalDataSource: FeedLocalDataSource,
        feedRemoteDataSource: FeedRemoteDataSource
    ) {
        let feedUUID = feedUUID
        let userUUID = UserManager.shared.user.userUUID
        self.feedLocalDataSource = feedLocalDataSource
        self.feedRemoteDataSource = feedRemoteDataSource

        updater = Updater<Feed, FirestoreServiceError>(
            onRemoteCombine: { feed in
                feedRemoteDataSource.updateFeedPublisher(
                    feedUUID: feedUUID,
                    userUUID: userUUID,
                    feed: feed
                )
            },
            onLocalCombine: { feedLocalDataSource.normalFeedPublisher(feedUUID: feedUUID) },
            onLocal: { feedLocalDataSource.cachedNormalFeed(feedUUID: feedUUID) },
            onUpdateLocal: { feedLocalDataSource.toggleScrapFeed(feedUUID: feedUUID) }
        )

        updater.configure { [weak self] status, data in
            guard let self = self else { return }
//            print("\(#fileID) | updater: \(status)")

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
        input.scrapToggleButtonDidTap
            .sink { [weak self] _ in
                self?.updater.update()
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
