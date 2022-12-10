//
//  BCFirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

protocol BCFirestoreService {
}

final class DefaultBCFirestoreService {

    private let firestoreService: FirestoreService
    private var lastSnapShot: QueryDocumentSnapshot?
    private let paginateCount = 10

    private var feedQuery: Query {
        return firestoreService.createPaginateQuery(
            collectionPath: FirestoreCollection.feed.path,
            field: "pubDate",
            count: paginateCount,
            lastSnapShot: lastSnapShot
        )
    }

    init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }

    convenience init() {
        let firestoreService = FirestoreService()
        self.init(firestoreService: firestoreService)
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
        let feed = try await firestoreService.getDocument(collectionPath: feedPath, document: feedUUID)
        
        return feed
    }

    func fetchUser(userUUID: String) async throws -> FirestoreData {
        let userPath = FirestoreCollection.user.path
        let user = try await firestoreService.getDocument(collectionPath: userPath, document: userUUID)
        
        return user
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
        
        try await firestoreService.appendDocument(
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
