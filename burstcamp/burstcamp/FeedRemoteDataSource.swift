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

final class FeedRemoteDataSource {

    typealias Failure = FirestoreServiceError

    static let shared = FeedRemoteDataSource()

    private let firestoreService: FirestoreService

    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func normalFeedListPublisher(userUUID: String) -> AnyPublisher<[Feed], Failure> {
        let path = FirestoreCollection.normalFeed.path
        return feedListPublisher(path)
    }

    func recommendFeedListPublisher(userUUID: String) -> AnyPublisher<[Feed], Failure> {
        let path = FirestoreCollection.recommendFeed.path
        return feedListPublisher(path)
    }

    func scrapFeedListPublisher(userUUID: String) -> AnyPublisher<[Feed], Failure> {
        let path = FirestoreCollection.scrapFeeds(userUUID: userUUID).path
        return feedListPublisher(path)
    }

    func updateFeedPublisher(
        feedUUID: String,
        userUUID: String,
        feed: Feed
    ) -> AnyPublisher<Void, FirestoreServiceError> {
        return Future {
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
                let scrapDate = Timestamp(date: Date())
                try await self.firestoreService.createDocument(
                    FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
                    document: userUUID,
                    data: [
                        "userUUID": userUUID,
                        // TODO: TimeStamp 분리 필요
                        "scrapDate": scrapDate
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
                        "scrapDate": scrapDate
                    ]
                )
            }
        }
        .mapError { error in
            return error as?
            FirestoreServiceError ??
            FirestoreServiceError.errorCastingFail(message: "file: \(#file), line: \(#line)")
        }
        .share()
        .eraseToAnyPublisher()
    }

    private func feedListPublisher(
        _ collectionPath: String,
        userUUID: String = UserManager.shared.user.userUUID
    ) -> AnyPublisher<[Feed], Failure> {
        return Future {
            try await self.firestoreService.getCollection(collectionPath)
                .asyncMap { feedData -> Feed in
                    let feedAPIModel = FeedAPIModel(data: feedData)
                    let writerData = try await self.firestoreService.getDocument(
                        FirestoreCollection.user.path,
                        document: feedAPIModel.writerUUID
                    )
                    let scrapUsers = try await self.firestoreService.getCollection(
                        FirestoreCollection.scrapUsers(feedUUID: feedAPIModel.feedUUID).path
                    )
                    let scrapCount = scrapUsers.count
                    let isScraped = scrapUsers.contains(where: { dict in
                        let userUUIDData = dict["userUUID"] as? String
                        return userUUIDData == userUUID
                    })
                    let feedWriter = FeedWriter(data: writerData)
                    let feed = Feed(
                        feedAPIModel: feedAPIModel,
                        feedWriter: feedWriter,
                        scrapCount: scrapCount,
                        isScraped: isScraped
                    )
                    return feed
                }
        }
        .mapError { error in
            return error as?
            FirestoreServiceError ??
            FirestoreServiceError.errorCastingFail(message: "file: \(#file), line: \(#line)")
        }
        .eraseToAnyPublisher()
    }
}
