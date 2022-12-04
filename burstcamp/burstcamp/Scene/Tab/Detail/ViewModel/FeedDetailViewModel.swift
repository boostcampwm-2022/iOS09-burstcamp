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
    private var scrapButtonIsEnabled = CurrentValueSubject<Bool, Never>(true)

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
        let scrapButtonIsEnabled: AnyPublisher<Bool, Never>
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
            feedDidUpdate: feedDidUpdate,
            openBlog: openBlog,
            openActivityView: openActivityView,
            scrapButtonToggle: scrapButtonToggle,
            scrapButtonIsEnabled: scrapButtonIsEnabled.eraseToAnyPublisher()
        )
    }

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

    private func fetchFeed(uuid: String) {
        Task {
            // TODO: 오류 처리
            let feedDict = try await requestGetFeed(uuid: uuid)
            let feedDTO = FeedDTO(data: feedDict)
            let feedWriterDict = try await requestGetFeedWriter(uuid: feedDTO.writerUUID)
            let feedWriter = FeedWriter(data: feedWriterDict)
            let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)

            self.feed.send(feed)
        }
    }

    private func requestDeleteFeedScrapUser(uuid: String) async throws {
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

    private func requestAppendFeedScrapUser(uuid: String) async throws {
        let userUUID = UserManager.shared.user.userUUID
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

    private func requestGetFeed(uuid: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.feed.reference
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
        }
    }

    private func requestGetFeedWriter(uuid: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.user.reference
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
        }
    }
}
