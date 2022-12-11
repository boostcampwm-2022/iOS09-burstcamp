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

    func normalFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return feedListPublisher(feedType: .normal)
    }

    func recommendFeedListPublisher() -> AnyPublisher<[Feed], Failure> {
        return feedListPublisher(feedType: .recommend)
    }

    private func feedListPublisher(feedType: FeedCellType) -> AnyPublisher<[Feed], Failure> {
        return Future {
            try await self.firestoreService.getCollection(collection: feedType.collectionName)
                .asyncMap { feedData -> Feed in
                    let feedAPIModel = FeedAPIModel(data: feedData)
                    let writerData = try await self.firestoreService.getDocument(
                        collectionPath: "user",
                        document: feedAPIModel.writerUUID
                    )
                    let feedWriter = FeedWriter(data: writerData)
                    let feed = Feed(feedAPIModel: feedAPIModel, feedWriter: feedWriter)
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

    func updateFeedPublisher(
        feedUUID: String,
        userUUID: String,
        scrapState: Bool
    ) -> AnyPublisher<Void, FirestoreServiceError> {
        return Future {
            switch scrapState {
            case true:
                try await self.firestoreService.deleteDocument(
                    collectionPath: FirestoreCollection.scrapUser(feedUUID: feedUUID).path,
                    document: userUUID
                )
                try await self.firestoreService.deleteDocumentArrayField(
                    collectionPath: FirestoreCollection.user.path,
                    document: userUUID,
                    arrayName: "scrapFeedUUIDs",
                    value: feedUUID
                )
            case false:
                try await self.firestoreService.createDocument(
                    collectionPath: FirestoreCollection.scrapUser(feedUUID: feedUUID).path,
                    document: userUUID,
                    value: [
                        "userUUID": userUUID,
                        // TODO: TimeStamp 분리 필요
                        "scrapDate": Timestamp(date: Date())
                    ]
                )
                try await self.firestoreService.appendDocumentArrayField(
                    collectionPath: FirestoreCollection.user.path,
                    document: userUUID,
                    arrayName: "scrapFeedUUIDs",
                    value: feedUUID
                )
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
