//
//  FeedScrapViewModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/05.
//

import Combine
import Foundation

import FirebaseFirestore

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

    init(feedUUID: String) {
        self.feedUUID = feedUUID
        self.userUUID = UserManager.shared.user.userUUID
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
                    try await requestDeleteScrapUser(userUUID, at: feedUUID)
                    try await requestDeleteUserScrapFeedUUID(feedUUID, at: userUUID)
                case false:
                    try await requestAppendScrapUser(userUUID, at: feedUUID)
                    try await requestAppendUserScrapFeedUUID(feedUUID, at: userUUID)
                }
                self.dbUpdateResult.send(true)
            } catch {
                debugPrint(error.localizedDescription)
                self.dbUpdateResult.send(false)
            }
        }
    }

    // MARK: Append

    private func requestDeleteUserScrapFeedUUID(
        _ feedUUID: String,
        at userUUID: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.user.reference
                .document(userUUID)
                .updateData([
                    "scrapFeedUUIDs": FieldValue.arrayRemove([feedUUID])
                ]) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    private func requestDeleteScrapUser(_ userUUID: String, at feedUUID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.scrapUser(feedUUID: feedUUID).reference
                .document(UserManager.shared.user.userUUID)
                .delete { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    // MARK: Append

    private func requestAppendScrapUser(
        _ userUUID: String
        , at feedUUID: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.scrapUser(feedUUID: feedUUID).reference
                .document(userUUID)
                .setData([
                    "userUUID": userUUID,
                    "scrapDate": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    private func requestAppendUserScrapFeedUUID(
        _ feedUUID: String,
        at userUUID: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.user.reference
                .document(userUUID)
                .updateData([
                    "scrapFeedUUIDs": FieldValue.arrayUnion([feedUUID])
                ]) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }
}
