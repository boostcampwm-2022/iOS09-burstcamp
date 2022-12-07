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
    func countFeedScarp() async throws -> Int
    func appendUserToFeedScrapUser() async throws
    func deleteUserFromFeedScrapUser() async throws
    func appendFeedUUIDToUserScrapFeed() async throws
    func deleteFeedUUIDFromUserScrapFeed() async throws
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

    func countFeedScarp() async throws -> Int {
        return 0
    }

    func appendUserToFeedScrapUser() async throws {
    }

    func deleteUserFromFeedScrapUser() async throws {
    }

    func appendFeedUUIDToUserScrapFeed() async throws {
    }

    func deleteFeedUUIDFromUserScrapFeed() async throws {
    }
}
