//
//  FeedScrapViewModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/05.
//

import Combine
import Foundation

enum UpdateMethod {
    case append
    case remove
}

final class FeedScrapViewModel {
    private var cancelBag = Set<AnyCancellable>()

    private let dbUpdateResult = PassthroughSubject<Bool, Never>()
    private let scrapToggleButtonIsEnabled = PassthroughSubject<Bool, Never>()
    private let scrapCountUp = PassthroughSubject<Bool, Never>()

    private let feedUUID: String
    private let userUUID: String
    private let firestoreFeedService: FirestoreFeedService

    init(feedUUID: String, firestoreFeedService: FirestoreFeedService) {
        self.feedUUID = feedUUID
        self.userUUID = UserManager.shared.user.userUUID
        self.firestoreFeedService = firestoreFeedService
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let scrapToggleButtonDidTap: AnyPublisher<Bool, Never>
    }

    struct Output {
        let scrapToggleButtonState: AnyPublisher<Bool, Never>
        let scrapToggleButtonIsEnabled: AnyPublisher<Bool, Never>
    }

    func transform(input: Input) -> Output {
        input.scrapToggleButtonDidTap
            .throttle(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main,
                latest: false
            )
            .sink { [weak self] scrapState in
                guard let self = self else { return }
                self.updateFeed(
                    userUUID: self.userUUID,
                    feedUUID: self.feedUUID,
                    scrapState: scrapState
                )
                self.scrapToggleButtonIsEnabled.send(false)
            }
            .store(in: &cancelBag)

        let sharedDBUpdateResult = dbUpdateResult
            .map { _ in Void() }
            .share()

        sharedDBUpdateResult
            .sink { [weak self] _ in
                guard let feedUUID = self?.feedUUID else { return }
                let state = UserManager.shared.user.scrapFeedUUIDs.contains(feedUUID)
                self?.scrapCountUp.send(state)
                self?.scrapToggleButtonIsEnabled.send(true)
            }
            .store(in: &cancelBag)

        let scrapToggleButtonState = input.viewDidLoad
            .merge(with: sharedDBUpdateResult)
            .map { [weak self] _ in
                guard let feedUUID = self?.feedUUID else { return false }
                let state = UserManager.shared.user.scrapFeedUUIDs.contains(feedUUID)
                return state
            }
            .eraseToAnyPublisher()

        return Output(
            scrapToggleButtonState: scrapToggleButtonState,
            scrapToggleButtonIsEnabled: scrapToggleButtonIsEnabled.eraseToAnyPublisher()
        )
    }

    var getScrapCountUp: AnyPublisher<Bool, Never> {
        return scrapCountUp.eraseToAnyPublisher()
    }

    private func updateFeed(userUUID: String, feedUUID: String, scrapState: Bool) {
        Task {
            do {
                switch scrapState {
                case true:
                    try await firestoreFeedService.deleteUserFromFeed(
                        userUUID: userUUID,
                        at: feedUUID
                    )
                    try await firestoreFeedService.deleteFeedUUIDFromUser(
                        feedUUID: feedUUID,
                        at: userUUID
                    )
                case false:
                    try await firestoreFeedService.appendUserToFeed(
                        userUUID: userUUID,
                        at: feedUUID
                    )
                    try await firestoreFeedService.appendFeedUUIDToUser(
                        feedUUID: feedUUID, at: userUUID
                    )
                }
                self.dbUpdateResult.send(true)
            } catch {
                debugPrint(error.localizedDescription)
                self.dbUpdateResult.send(false)
            }
        }
    }
}
