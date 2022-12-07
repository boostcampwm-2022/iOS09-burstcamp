//
//  FirestoreFeed.swift
//  burstcamp
//
//  Created by youtak on 2022/12/07.
//

import Foundation

import FirebaseFirestore

protocol FirestoreFeedService {
    func createLatestQuery() -> Query
    func createPaginateQuery(lastSnapShot: QueryDocumentSnapshot) -> Query
    func fetchRecommendFeedDTOs() async throws -> [[String: Any]]
    func fetchLatestFeedDTOs() async throws -> (
        lastestFeedDTOS: [[String: Any]],
        lastSnapShot: QueryDocumentSnapshot?
    )
    func fetchMoreFeeds(query: Query) async throws -> (
        lastestFeedDTOS: [[String: Any]],
        lastSnapShot: QueryDocumentSnapshot?
    )
    func fetchFeedDTO(feedUUID: String) async throws -> [String: Any]
    func fetchUser(userUUID: String) async throws -> [String: Any]
    func countFeedScarp(feedUUID: String) async throws -> Int
    func appendUserToFeed(userUUID: String, at feedUUID: String) async throws
    func deleteUserFromFeed(userUUID: String, at feedUUID: String) async throws
    func appendFeedUUIDToUser(feedUUID: String, at userUUID: String) async throws
    func deleteFeedUUIDFromUser(feedUUID: String, at userUUID: String) async throws
}

final class DefaultFirestoreFeedService: FirestoreFeedService {

    func createLatestQuery() -> Query {
        return FirestoreCollection.feed.reference
            .order(by: "pubDate", descending: true)
            .limit(to: 5)
    }

    func createPaginateQuery(lastSnapShot: QueryDocumentSnapshot) -> Query {
        return FirestoreCollection.feed.reference
            .order(by: "pubDate", descending: true)
            .limit(to: 5)
            .start(afterDocument: lastSnapShot)
    }

    func fetchRecommendFeedDTOs() async throws -> [[String: Any]] {
        try await withCheckedThrowingContinuation({ continuation in
            FirestoreCollection.recommendFeed.reference
                .getDocuments { querySnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let querySnapShot = querySnapShot else {
                        continuation.resume(throwing: FirebaseError.fetchFeedError)
                        return
                    }
                    let recommendFeeds = querySnapShot.documents.map { queryDocumentSnapshot in
                        let recommendFeed = queryDocumentSnapshot.data()
                        return recommendFeed
                    }
                    continuation.resume(returning: recommendFeeds)
                }
        })
    }

    func fetchLatestFeedDTOs() async throws -> (
        lastestFeedDTOS: [[String: Any]],
        lastSnapShot: QueryDocumentSnapshot?
    ) {
        try await withCheckedThrowingContinuation({ continuation in
            var lastSnapShot: QueryDocumentSnapshot?
            let feedQuery = createLatestQuery()

            feedQuery
                .getDocuments { querySnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let querySnapShot = querySnapShot else {
                        continuation.resume(throwing: FirebaseError.fetchFeedError)
                        return
                    }
                    lastSnapShot = querySnapShot.documents.last
                    if lastSnapShot == nil { // 응답한 Feed가 없는 경우
                        continuation.resume(throwing: FirebaseError.lastFetchError)
                        return
                    }

                    let normalFeeds = querySnapShot.documents.map { queryDocumentSnapshot in
                        let normalFeed = queryDocumentSnapshot.data()
                        return normalFeed
                    }
                    continuation.resume(returning: (normalFeeds, lastSnapShot))
                }
        })
    }

    func fetchMoreFeeds(query: Query) async throws -> (
        lastestFeedDTOS: [[String: Any]],
        lastSnapShot: QueryDocumentSnapshot?
    ) {
        try await withCheckedThrowingContinuation({ continuation in
            var lastSnapShot: QueryDocumentSnapshot?

            query
                .getDocuments { querySnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let querySnapShot = querySnapShot else {
                        continuation.resume(throwing: FirebaseError.fetchFeedError)
                        return
                    }
                    lastSnapShot = querySnapShot.documents.last
                    if lastSnapShot == nil { // 응답한 Feed가 없는 경우
                        continuation.resume(throwing: FirebaseError.lastFetchError)
                        return
                    }

                    let normalFeeds = querySnapShot.documents.map { queryDocumentSnapshot in
                        let normalFeed = queryDocumentSnapshot.data()
                        return normalFeed
                    }
                    continuation.resume(returning: (normalFeeds, lastSnapShot))
                }
        })
    }

    func fetchFeedDTO(feedUUID: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation({ continuation in
            FirestoreCollection.feed.reference
                .document(feedUUID)
                .getDocument { documentSnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let snapShot = documentSnapShot,
                          let feedDTO = snapShot.data()
                    else {
                        continuation.resume(throwing: FirebaseError.fetchUserError)
                        return
                    }
                    continuation.resume(returning: feedDTO)
                }
        })
    }

    func fetchUser(userUUID: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation({ continuation in
            FirestoreCollection.user.reference
                .document(userUUID)
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

    func countFeedScarp(feedUUID: String) async throws -> Int {
        let path = FirestoreCollection.scrapUser(feedUUID: feedUUID).path
        let countQuery = Firestore.firestore().collection(path).count
        let collectionCount = try await countQuery.getAggregation(source: .server)
        return Int(truncating: collectionCount.count)
    }

    func appendUserToFeed(userUUID: String, at feedUUID: String) async throws {
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

    func deleteUserFromFeed(userUUID: String, at feedUUID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.scrapUser(feedUUID: feedUUID).reference
                .document(userUUID)
                .delete { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    func appendFeedUUIDToUser(feedUUID: String, at userUUID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.user.reference
                .document(userUUID)
                .updateData([
                    "scrapFeedUUIDs": FieldValue.arrayUnion([feedUUID])
                ]) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    func deleteFeedUUIDFromUser(feedUUID: String, at userUUID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            FirestoreCollection.user.reference
                .document(userUUID)
                .updateData([
                    "scrapFeedUUIDs": FieldValue.arrayRemove([feedUUID])
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
