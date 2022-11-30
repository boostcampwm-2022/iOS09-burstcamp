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
    private var feed = CurrentValueSubject<Feed?, Never>(nil)

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
        let scrapButtonDidTap: AnyPublisher<Void, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed, Never>
        let openBlog: AnyPublisher<URL, Never>
        let scrapButtonToggle: AnyPublisher<Void, Never>
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

        return Output(
            feedDidUpdate: feedDidUpdate,
            openBlog: openBlog,
            scrapButtonToggle: input.scrapButtonDidTap,
            openActivityView: openActivityView
        )
    }

    private func fetchFeed(uuid: String) {
        Task {
            let feedDict = await requestFeed(uuid: uuid)
            let feedDTO = FeedDTO(data: feedDict)
            print(feedDTO)
            let feedWriterDict = await requestFeedWriter(uuid: feedDTO.writerUUID)
            let feedWriter = FeedWriter(data: feedWriterDict)
            let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)

            self.feed.send(feed)
        }
    }

    private func requestFeed(uuid: String) async -> [String: Any] {
        await withCheckedContinuation({ continuation in
            let db = Firestore.firestore()
            db.collection("feed").whereField("feedUUID", isEqualTo: uuid)
                .getDocuments() { (querySnapshot, err) in
                    guard let snapShot = querySnapshot,
                          let feedDoc = snapShot.documents.first
                    else {
                        fatalError("해당 피드가 존재하지 않음.")
                    }
                    continuation.resume(returning: feedDoc.data())
                }
        })
    }

    private func requestFeedWriter(uuid: String) async -> [String: Any] {
        await withCheckedContinuation({ continuation in
            let db = Firestore.firestore()
            db.collection("User")
                .document(uuid)
                .getDocument { (documentSnapShot, error) in
                    guard let snapShot = documentSnapShot,
                          let userData = snapShot.data()
                    else {
                        fatalError("해당 유저가 존재하지 않음.")
                    }
                    continuation.resume(returning: userData)
                }
        })
    }
}
