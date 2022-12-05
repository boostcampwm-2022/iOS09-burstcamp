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

    private let feed = CurrentValueSubject<Feed?, Never>(nil)
    private let dbUpdateResult = PassthroughSubject<Bool, Never>()
    private let scrapToggleButtonIsEnabled = PassthroughSubject<Bool, Never>()

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
        let viewDidLoad: AnyPublisher<Void, Never>
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let scrapToggleButtonDidTap: AnyPublisher<Bool, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed, Never>
        let openBlog: AnyPublisher<URL, Never>
        let openActivityView: AnyPublisher<String, Never>
        let scrapToggleButtonState: AnyPublisher<Bool, Never>
        let scrapToggleButtonIsEnabled: AnyPublisher<Bool, Never>
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

        input.scrapToggleButtonDidTap
            .throttle(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main,
                latest: false
            )
            .sink { [weak self] state in
                guard let feedUUID = self?.feed.value?.feedUUID else { return }
                self?.updateFeed(feedUUID: feedUUID, state: state)
                self?.scrapToggleButtonIsEnabled.send(false)
            }
            .store(in: &cancelBag)

        let sharedDBUpdateResult = dbUpdateResult
            .map { _ in Void() }
            .share()

        sharedDBUpdateResult
            .sink { _ in
                self.scrapToggleButtonIsEnabled.send(true)
            }
            .store(in: &cancelBag)

        let scrapToggleButtonState = input.viewDidLoad
            .merge(with: sharedDBUpdateResult)
            .map { [weak self] _ in
                guard let feedUUID = self?.feed.value?.feedUUID else { return false }
                return UserManager.shared.user.scrapFeedUUIDs.contains(feedUUID)
            }
            .eraseToAnyPublisher()

        return Output(
            feedDidUpdate: feedDidUpdate,
            openBlog: openBlog,
            openActivityView: openActivityView,
            scrapToggleButtonState: scrapToggleButtonState,
            scrapToggleButtonIsEnabled: scrapToggleButtonIsEnabled.eraseToAnyPublisher()
        )
    }

    private func updateFeed(feedUUID: String, state: Bool) {
        Task {
            do {
                switch state {
                case true:
                    try await requestDeleteScrapUser(at: feedUUID)
                    UserManager.shared.user.scrapFeedUUIDs.removeAll(where: { $0 == feedUUID })
                case false:
                    try await requestAppendScrapUser(at: feedUUID)
                    UserManager.shared.user.scrapFeedUUIDs.append(feedUUID)
                }
                self.dbUpdateResult.send(true)
            } catch {
                debugPrint(error.localizedDescription)
                self.dbUpdateResult.send(false)
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

    private func requestDeleteScrapUser(at feedUUID: String) async throws {
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

    private func requestAppendScrapUser(at feedUUID: String) async throws {
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
