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
                let uuid = self.feedData.feedUUID
                self.updateFeed(uuid: uuid, state: state)
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
    private func updateFeed(uuid: String, state: Bool) {
        Task {
            do {
                switch state {
                case true: try await requestDeleteFeedScrapUser(uuid: uuid)
                case false: try await requestAppendFeedScrapUser(uuid: uuid)
                }
                self.dbUpdateSucceed.send(true)
            } catch {
                self.dbUpdateSucceed.send(false)
            }
        }
    }

    private func requestDeleteFeedScrapUser(uuid: String) async throws {
        let path = ["Feed", uuid, "scrapUserUUIDs", "userUUID"].joined(separator: "/")
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

    private func requestAppendFeedScrapUser(uuid: String) async throws {
        let path = ["Feed", uuid, "scrapUserUUIDs", "userUUID"].joined(separator: "/")
        try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore()
                .document(path)
                .setData([
                    "userUUID": "userUUID",
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
}
