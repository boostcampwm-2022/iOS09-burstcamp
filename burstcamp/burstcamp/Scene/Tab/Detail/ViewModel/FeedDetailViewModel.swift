//
//  FeedDetailViewModel.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import Combine
import Foundation

import FirebaseFirestore

final class FeedDetailViewModel {

    private var cancelBag = Set<AnyCancellable>()

    private var feed = CurrentValueSubject<Feed?, Never>(nil)
    private var dbUpdateSucceed = CurrentValueSubject<Bool?, Never>(nil)

    init() { }

    convenience init(feed: Feed) {
        self.init()
        self.feed.send(feed)
    }

    convenience init(feedUUID: String) {
        self.init()
        self.fetchFeed(uuid: feedUUID)
    }

    struct Input {
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let scrapButtonDidTap: AnyPublisher<Bool, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed, Never>
        let openBlog: AnyPublisher<URL, Never>
        let openActivityView: AnyPublisher<String, Never>
        let scrapButtonToggle: AnyPublisher<Void, Never>
        let scrapButtonDisable: AnyPublisher<Void, Never>
        let scrapButtonEnable: AnyPublisher<Void, Never>
    }

    func transform(input: Input) -> Output {
        let feedDidUpdate = feed
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let openBlog = input.blogButtonDidTap
            .compactMap { self.feed.value?.url }
            .compactMap { URL(string: $0) }
            .eraseToAnyPublisher()

        let openActivityView = input.shareButtonDidTap
            .compactMap { self.feed.value?.url }
            .eraseToAnyPublisher()

        let sharedScrapButtonDidTap = input.scrapButtonDidTap
            .share()

        sharedScrapButtonDidTap
            .sink { state in
                guard let uuid = self.feed.value?.feedUUID else { return }
                self.updateFeed(uuid: uuid, state: state)
            }
            .store(in: &cancelBag)

        let scrapButtonDisabled = sharedScrapButtonDidTap
            .map { _ in Void() }
            .eraseToAnyPublisher()

        let dbUpdateResult = self.dbUpdateSucceed
            .print("dbUpdate")
            .eraseToAnyPublisher()
            .share()

        let scrapButtonEnabled = dbUpdateResult
            .filter { $0 != nil }
            .map { _ in Void() }
            .eraseToAnyPublisher()

        let scrapButtonToggle = dbUpdateResult
            .filter { $0 == true }
            .map { _ in Void() }
            .print("toggle")
            .eraseToAnyPublisher()

        return Output(
            feedDidUpdate: feedDidUpdate,
            openBlog: openBlog,
            openActivityView: openActivityView,
            scrapButtonToggle: scrapButtonToggle,
            scrapButtonDisable: scrapButtonDisabled,
            scrapButtonEnable: scrapButtonEnabled
        )
    }

    private func updateFeed(uuid: String, state: Bool) {
        Task {
            do {
                switch state {
                case true: try await requestDeleteFeedScrapUser(uuid: uuid)
                case false: try await requestCreateFeedScrapUser(uuid: uuid)
                }
            } catch {
                self.dbUpdateSucceed.send(false)
                return
            }
            self.dbUpdateSucceed.send(true)
        }
    }

    private func fetchFeed(uuid: String) {
        Task {
            // TODO: 오류 처리
            let feedDict = try await requestGetFeed(uuid: uuid)
            print(feedDict.keys)
            let feedDTO = FeedDTO(data: feedDict)
            let feedWriterDict = try await requestGetFeedWriter(uuid: feedDTO.writerUUID)
            let feedWriter = FeedWriter(data: feedWriterDict)
            let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)

            self.feed.send(feed)
        }
    }

    private func requestDeleteFeedScrapUser(uuid: String) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("feed")
                .document(uuid)
                .collection("scrapUserUUIDs")
                .document("userUUID")
                .delete() { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        }) as Void
    }

    private func requestCreateFeedScrapUser(uuid: String) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("feed")
                .document(uuid)
                .collection("scrapUserUUIDs")
                .document("userUUID")
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
        }) as Void
    }

    private func requestGetFeed(uuid: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("feed")
                .document(uuid)
                .getDocument { documentSnapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let snapShot = documentSnapshot,
                          let feedData = snapShot.data()
                    else {
                        continuation.resume(throwing: FirebaseError.fetchFeedError)
                        return
                    }
                    continuation.resume(returning: feedData)
                }
        })
    }

    private func requestGetFeedWriter(uuid: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("User")
                .document(uuid)
                .getDocument { documentSnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let snapShot = documentSnapShot,
                          let userData = snapShot.data()
                    else {
                        continuation.resume(throwing: FirebaseError.fetchUserError)
                        return
                    }
                    continuation.resume(returning: userData)
                }
        })
    }
}
