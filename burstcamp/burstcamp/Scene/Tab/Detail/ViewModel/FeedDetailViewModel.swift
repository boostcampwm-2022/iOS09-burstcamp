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
    private var feed: Feed?

    init(feed: Feed?) {
        self.feed = feed
    }

    convenience init(feedUUID: String) {
        self.init(feed: nil)
        self.fetchFeed(uuid: feedUUID)
    }

    struct Input {
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let scrapButtonDidTap: AnyPublisher<Void, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let openBlog: AnyPublisher<URL, Never>
        let scrapButtonToggle: AnyPublisher<Void, Never>
        let openActivityView: AnyPublisher<String, Never>
    }

    func transform(input: Input) -> Output {
        let openBlog = input.blogButtonDidTap
            .compactMap { self.feed?.url }
            .compactMap { URL(string: $0) }
            .eraseToAnyPublisher()

        let openActivityView = input.shareButtonDidTap
            .compactMap { self.feed?.url }
            .eraseToAnyPublisher()

        return Output(
            openBlog: openBlog,
            scrapButtonToggle: input.scrapButtonDidTap,
            openActivityView: openActivityView
        )
    }

    private func fetchFeed(uuid: String) {
        Task {
            var feedDict = await requestFeed(uuid: uuid)

            guard let pubDate = feedDict["pubDate"] as? Timestamp else {
                fatalError("캐스팅 에러")
            }
            let interval = Double(pubDate.seconds) as TimeInterval
            feedDict["pubDate"] = Date(timeIntervalSince1970: interval).
            guard let feed = try? Feed(feedDict) else {
                fatalError("디코딩 에러")
            }
            self.feed = feed
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
}
