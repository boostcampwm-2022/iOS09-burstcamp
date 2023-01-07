//
//  FeedRemoteDataSource.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import Combine
import Foundation

// TODO: firestore 메서드 분리해서 없애야함
import class FirebaseFirestore.Timestamp
import class FirebaseFirestore.Query
import class FirebaseFirestore.CollectionReference

final class FeedRemoteDataSource {

    static let shared = FeedRemoteDataSource()

    private let firestoreService: FirestoreService

    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func normalFeedListPublisher(userUUID: String) -> AnyPublisher<[Feed], Error> {
        let path = FirestoreCollection.normalFeed.path
        return feedListPublisher(path)
    }

    func recommendFeedListPublisher(userUUID: String) -> AnyPublisher<[Feed], Error> {
        let path = FirestoreCollection.recommendFeed.path
        return feedListPublisher(path)
    }

    func scrapFeedListPublisher(userUUID: String) -> AnyPublisher<[Feed], Error> {
        let path = FirestoreCollection.scrapFeeds(userUUID: userUUID).path
        return feedListPublisher(path)
    }

    /// - Parameters:
    ///   - feed: 현재 Local에 있는 Feed
    func updateFeedPublisher(
        feedUUID: String,
        userUUID: String,
        feed: Feed
    ) -> AnyPublisher<Feed, Error> {
        return Future {
            // feed의 스크랩 상태를 변경 해준다.
            var newFeed = feed
            newFeed.toggleScrap()

            switch feed.isScraped {
            case true:
                try await self.firestoreService.deleteDocument(
                    FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
                    document: userUUID
                )
                try await self.firestoreService.deleteDocument(
                    FirestoreCollection.scrapFeeds(userUUID: userUUID).path,
                    document: feedUUID
                )
            case false:
                try await self.firestoreService.createDocument(
                    FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
                    document: userUUID,
                    data: [
                        "userUUID": userUUID,
                        // TODO: TimeStamp 분리 필요
                        "scrapDate": Timestamp(date: newFeed.scrapDate ?? Date())
                    ]
                )
                try await self.firestoreService.createDocument(
                    FirestoreCollection.scrapFeeds(userUUID: userUUID).path,
                    document: feedUUID,
                    data: [
                        "feedUUID": feedUUID,
                        "writerUUID": feed.writer.userUUID,
                        "title": feed.title,
                        "pubDate": Timestamp(date: feed.pubDate),
                        "url": feed.url,
                        "thumbnailURL": feed.thumbnailURL,
                        "content": feed.content,
                        "scrapDate": Timestamp(date: newFeed.scrapDate ?? Date())
                    ]
                )
            }
            // 상태가 바뀐 피드를 리턴한다.
            return newFeed
        }
        .share()
        .eraseToAnyPublisher()
    }

    private func feedListPublisher(
        _ collectionPath: String,
        userUUID: String = UserManager.shared.user.userUUID
    ) -> AnyPublisher<[Feed], Error> {
        return Future {
            try await self.firestoreService.getCollection(collectionPath)
                .asyncMap { feedData -> Feed in
                    let feedAPIModel = FeedAPIModel(data: feedData)
                    let scrapUsers = try await self.firestoreService.getCollection(
                        FirestoreCollection.scrapUsers(feedUUID: feedAPIModel.feedUUID).path
                    )
                    let isScraped = scrapUsers.contains(where: { dict in
                        let userUUIDData = dict["userUUID"] as? String
                        return userUUIDData == userUUID
                    })
                    let feed = Feed(
                        feedAPIModel: feedAPIModel,
                        isScraped: isScraped
                    )
                    return feed
                }
        }
        .eraseToAnyPublisher()
    }
}
