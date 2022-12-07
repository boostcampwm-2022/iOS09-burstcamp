//
//  FirestoreFeed.swift
//  burstcamp
//
//  Created by youtak on 2022/12/07.
//

import Foundation

import FirebaseFirestore

protocol FirestoreFeedService {
    func fetchRecommendFeeds() async throws -> [String: Any]
    func fetchLatestFeeds() async throws -> [[String: Any]]
    func createLatestQuery() -> Query
    func createPaginateQuery(lastSnapShot: QueryDocumentSnapshot) -> Query
    func fetchMoreFeeds() async throws -> [[String: Any]]
    func fetchFeed() async throws -> [String: Any]
    func fetchUser() async throws -> [String: Any]
    func countFeedScarp(feedUUID: String) async throws -> Int
    func appendUserToFeed(userUUID: String, at feedUUID: String) async throws
    func deleteUserFromFeed(userUUID: String, at feedUUID: String) async throws
    func appendFeedUUIDToUser(feedUUID: String, at userUUID: String) async throws
    func deleteFeedUUIDFromUser(feedUUID: String, at userUUID: String) async throws
}

final class DefaultFirestoreFeedService: FirestoreFeedService {

    func fetchRecommendFeeds() async throws -> [String: Any] {
        return [:]
    }

    func fetchLatestFeeds() async throws -> [[String: Any]] {
        return [[:]]
    }

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

    func fetchMoreFeeds() async throws -> [[String: Any]] {
        return [[:]]
    }

    func fetchFeed() async throws -> [String: Any] {
        return [:]
    }

    func fetchUser() async throws -> [String: Any] {
        return [:]
    }

    func countFeedScarp(feedUUID: String) async throws -> Int {
        let path = FirestoreCollection.scrapUser(feedUUID: uuid).path
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
