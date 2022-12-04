//
//  NormalFeedCellViewModel.swift
//  burstcamp
//
//  Created by youtak on 2022/12/04.
//

import Combine
import Foundation

import FirebaseFirestore

final class NormalFeedCellViewModel {

    var feedData: Feed

    private var dbUpdateSucceed = CurrentValueSubject<Bool?, Never>(nil)
    private var scrapButtonIsEnabled = CurrentValueSubject<Bool, Never>(true)
    var cancelBag = Set<AnyCancellable>()

    init(feed: Feed) {
        self.feedData = feed
    }

    struct Input {
        let cellStateIndexPath: AnyPublisher<Bool, Never>
    }

    struct Output {
        let cellScrapButtonToggle: AnyPublisher<Void, Never>
        let cellScrapButtonIsEnabled: AnyPublisher<Bool, Never>
    }

    func transform(input: Input) -> Output {
        input.cellStateIndexPath
            .sink { state in
                let feedUUID = self.feedData.feedUUID
                let userUUID = UserManager.shared.user.userUUID
                self.updateFeed(userUUID: userUUID, feedUUID: feedUUID, state: state)
                self.scrapButtonIsEnabled.send(false)
            }
            .store(in: &cancelBag)

        let dbUpdateResult = self.dbUpdateSucceed
            .eraseToAnyPublisher()
            .share()

        dbUpdateResult
            .filter { $0 != nil }
            .sink { _ in
                self.scrapButtonIsEnabled.send(true)
            }
            .store(in: &cancelBag)

        let scrapButtonToggle = dbUpdateResult
            .filter { $0 == true }
            .map { _ in Void() }
            .eraseToAnyPublisher()

        return Output(
            cellScrapButtonToggle: scrapButtonToggle,
            cellScrapButtonIsEnabled: scrapButtonIsEnabled.eraseToAnyPublisher()
        )
    }
}

extension NormalFeedCellViewModel {
    private func updateFeed(userUUID: String, feedUUID: String, state: Bool) {
        Task {
            do {
                switch state {
                case true:
                    try await requestDeleteFeedScrapUser(
                        feedUUID: feedUUID,
                        userUUID: userUUID
                    )
                    try await updateUserScrapFeedUUIDs(
                        userUUID: userUUID,
                        feedUUID: feedUUID,
                        update: .remove
                    )
                case false:
                    try await requestAppendFeedScrapUser(
                        feedUUID: feedUUID,
                        userUUID: userUUID
                    )
                    try await updateUserScrapFeedUUIDs(
                        userUUID: userUUID,
                        feedUUID: feedUUID,
                        update: .append
                    )
                }
                self.dbUpdateSucceed.send(true)
            } catch {
                self.dbUpdateSucceed.send(false)
            }
        }
    }

    private func requestDeleteFeedScrapUser(
        feedUUID: String,
        userUUID: String
    ) async throws {
        let path = ["Feed", feedUUID, "scrapUserUUIDs", userUUID].joined(separator: "/")
        try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore()
                .document(path)
                .delete { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    private func requestAppendFeedScrapUser(
        feedUUID: String,
        userUUID: String
    ) async throws {
        let path = ["Feed", feedUUID, "scrapUserUUIDs", userUUID].joined(separator: "/")
        try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore()
                .document(path)
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

    private func updateUserScrapFeedUUIDs(
        userUUID: String,
        feedUUID: String,
        update: FeedUpdate
    ) async throws {
        let path = ["User", userUUID].joined(separator: "/")
        let updateData = getUpdateData(update: update)
        try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore()
                .document(path)
                .updateData(updateData) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    private func getUpdateData(update: FeedUpdate) -> [AnyHashable: Any] {
        switch update {
        case .append:
            return ["scrapFeedUUIDs": FieldValue.arrayUnion(["feedUUID"])]
        case .remove:
            return ["scrapFeedUUIDs": FieldValue.arrayRemove(["feedUUID"])]
        }
    }
}

enum FeedUpdate {
    case append
    case remove
}
