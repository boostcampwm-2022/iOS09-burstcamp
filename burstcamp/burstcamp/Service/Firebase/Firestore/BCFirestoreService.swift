//
//  BCFirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

protocol BCFirestoreService {
    func fetchRecommendFeed() async throws -> [FirestoreData]
    func fetchLatestNormalFeeds() async throws -> [FirestoreData]
    func fetchMoreNormalFeeds() async throws -> [FirestoreData]
    func fetchFeed(feedUUID: String) async throws -> FirestoreData
    func fetchUser(userUUID: String) async throws -> FirestoreData
    func saveUser(userUUID: String, user: FirestoreData) async throws
    func updateUser(userUUID: String, data: FirestoreData) async throws
    func deleteUser(userUUID: String) async throws
    func addListenerToUser(userUUID: String) async throws -> FirestoreData
    func countFeedScrap(feedUUID: String) async throws -> Int
    func appendScrapUser(userUUID: String, at feedUUID: String) async throws
    func deleteScrapUser(userUUID: String, from feedUUID: String) async throws
    func appendFeedUUID(_ feedUUID: String, at userUUID: String) async throws
    func deleteFeedUUID(_ feedUUID: String, from userUUID: String) async throws
}

final class DefaultBCFirestoreService: BCFirestoreService {

    private let firestoreService: FirestoreService
    private var lastSnapShot: QueryDocumentSnapshot?
    private let paginateCount: Int

    private var feedQuery: Query {
        return firestoreService.createPaginateQuery(
            collectionPath: FirestoreCollection.feed.path,
            field: "pubDate",
            count: paginateCount,
            lastSnapShot: lastSnapShot
        )
    }

    init(firestoreService: FirestoreService, paginateCount: Int) {
        self.firestoreService = firestoreService
        self.paginateCount = paginateCount
    }

    convenience init(paginateCount: Int = 10) {
        let firestoreService = FirestoreService()
        self.init(firestoreService: firestoreService, paginateCount: paginateCount)
    }

    private func initFeedQuery() {
        self.lastSnapShot = nil
    }

    func fetchRecommendFeed() async throws -> [FirestoreData] {
        let recommendFeedPath = FirestoreCollection.recommendFeed.path
        return try await firestoreService.getCollection(collection: recommendFeedPath)
    }

    func fetchLatestNormalFeeds() async throws -> [FirestoreData] {
        initFeedQuery()
        let result = try await firestoreService.getCollection(query: feedQuery)
        self.lastSnapShot = result.lastSnapshot

        return result.collectionData
    }

    func fetchMoreNormalFeeds() async throws -> [FirestoreData] {
        let result = try await firestoreService.getCollection(query: feedQuery)
        self.lastSnapShot = result.lastSnapshot

        return result.collectionData
    }

    func fetchFeed(feedUUID: String) async throws -> FirestoreData {
        let feedPath = FirestoreCollection.feed.path
        let feed = try await firestoreService.getDocument(
            collectionPath: feedPath,
            document: feedUUID
        )

        return feed
    }

    func fetchUser(userUUID: String) async throws -> FirestoreData {
        let userPath = FirestoreCollection.user.path
        let user = try await firestoreService.getDocument(
            collectionPath: userPath,
            document: userUUID
        )

        return user
    }

    func saveUser(userUUID: String, user: FirestoreData) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.createDocument(
            collectionPath: userPath,
            document: userUUID,
            value: user
        )
    }

    func updateUser(userUUID: String, data: FirestoreData) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.updateDocument(
            collectionPath: userPath,
            document: userUUID,
            data: data
        )
    }

    func deleteUser(userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.deleteDocument(
            collectionPath: userPath,
            document: userUUID
        )
    }

    func addListenerToUser(userUUID: String) async throws -> FirestoreData {
        let userPath = FirestoreCollection.user.path
        let userData = try await firestoreService.addListenerToDocument(
            collectionPath: userPath,
            document: userUUID
        )

        return userData
    }

    func countFeedScrap(feedUUID: String) async throws -> Int {
        let scrapUserPath = FirestoreCollection.scrapUser(feedUUID: feedUUID).path
        let scrapCount = try await firestoreService.countCollection(collectionPath: scrapUserPath)

        return scrapCount
    }

    func appendScrapUser(userUUID: String, at feedUUID: String) async throws {
        let scrapUserPath = FirestoreCollection.scrapUser(feedUUID: feedUUID).path
        let value: [String: Any] = [
            "userUUID": userUUID,
            "scrapDate": Timestamp(date: Date())
        ]

        try await firestoreService.createDocument(
            collectionPath: scrapUserPath,
            document: userUUID,
            value: value
        )
    }

    func deleteScrapUser(userUUID: String, from feedUUID: String) async throws {
        let scrapUserPath = FirestoreCollection.scrapUser(feedUUID: feedUUID).path

        try await firestoreService.deleteDocument(
            collectionPath: scrapUserPath,
            document: userUUID
        )
    }

    func appendFeedUUID(_ feedUUID: String, at userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        let arrayName = "scrapFeedUUIDs"

        try await firestoreService.deleteDocumentArrayField(
            collectionPath: userPath,
            document: userUUID,
            arrayName: arrayName,
            value: feedUUID
        )
    }

    func deleteFeedUUID(_ feedUUID: String, from userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        let arrayName = "scrapFeedUUIDs"

        try await firestoreService.deleteDocumentArrayField(
            collectionPath: userPath,
            document: userUUID,
            arrayName: arrayName,
            value: feedUUID
        )
    }
}
