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
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed, Never>
        let openBlog: AnyPublisher<URL, Never>
        let openActivityView: AnyPublisher<String, Never>
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

        let sharedDBUpdateResult = dbUpdateResult
            .map { _ in Void() }
            .share()

        return Output(
            feedDidUpdate: feedDidUpdate,
            openBlog: openBlog,
            openActivityView: openActivityView
        )
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
