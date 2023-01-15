//
//  BCFirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

protocol BCFirestoreServiceProtocol {
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
    func addScrapUser(userUUID: String, at feedUUID: String) async throws
    func deleteScrapUser(userUUID: String, from feedUUID: String) async throws
    func addFeed(_ feed: FirestoreData, at userUUID: String) async throws
    func deleteFeed(_ feedUUID: String, from userUUID: String) async throws
    func saveFCMToken(_ fcmToken: String, to userUUID: String) async throws
}

final class BCFirestoreService: BCFirestoreServiceProtocol {

    private let firestoreService: FirestoreService
    private var lastSnapShot: QueryDocumentSnapshot?
    private let paginateCount: Int

    private var feedQuery: Query {
        return firestoreService.createPaginateQuery(
            FirestoreCollection.normalFeed.path,
            field: "pubDate",
            count: paginateCount,
            lastSnapShot: lastSnapShot
        )
    }

    init(firestoreService: FirestoreService,paginateCount: Int) {
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
        return try await firestoreService.getCollection(recommendFeedPath)
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
        let feedPath = FirestoreCollection.normalFeed.path
        let feed = try await firestoreService.getDocument(feedPath, document: feedUUID)

        return feed
    }

    func fetchUser(userUUID: String) async throws -> FirestoreData {
        let userPath = FirestoreCollection.user.path
        let user = try await firestoreService.getDocument(userPath, document: userUUID)

        return user
    }

    func saveUser(userUUID: String, user: FirestoreData) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.createDocument(userPath, document: userUUID, data: user)
    }

    func updateUser(userUUID: String, data: FirestoreData) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.updateDocument(userPath, document: userUUID, data: data)
    }

    func deleteUser(userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.deleteDocument(userPath, document: userUUID)
    }

    func addListenerToUser(userUUID: String) async throws -> FirestoreData {
        let userPath = FirestoreCollection.user.path
        let userData = try await firestoreService.addListenerToDocument(userPath, document: userUUID)

        return userData
    }

    func countFeedScrap(feedUUID: String) async throws -> Int {
        let scrapUsersPath = FirestoreCollection.scrapUsers(feedUUID: feedUUID).path
        let scrapCount = try await firestoreService.countCollection(scrapUsersPath)

        return scrapCount
    }

    func addScrapUser(userUUID: String, at feedUUID: String) async throws {
        let scrapUsersPath = FirestoreCollection.scrapUsers(feedUUID: feedUUID).path
        let data: [String: Any] = [
            "userUUID": userUUID,
            "scrapDate": Timestamp(date: Date())
        ]

        try await firestoreService.createDocument(scrapUsersPath, document: userUUID, data: data)
    }

    func deleteScrapUser(userUUID: String, from feedUUID: String) async throws {
        let scrapUsersPath = FirestoreCollection.scrapUsers(feedUUID: feedUUID).path

        try await firestoreService.deleteDocument(scrapUsersPath, document: userUUID)
    }

    func addFeed(_ feed: FirestoreData, at userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        let arrayName = "scrapFeedUUIDs"

//        try await firestoreService.deleteDocumentArrayField(
//            userPath,
//            document: userUUID,
//            arrayName: arrayName
//            data: feedUUID
//        )
    }

    func deleteFeed(_ feedUUID: String, from userUUID: String) async throws {
        let feedScrapUserPath = FirestoreCollection.scrapFeeds(userUUID: userUUID).path

        try await firestoreService.deleteDocument(
            feedScrapUserPath,
            document: feedUUID
        )
    }

    func saveFCMToken(_ fcmToken: String, to userUUID: String) async throws {
        let fcmToken = FCMToken(fcmToken: fcmToken)
        guard let data = fcmToken.asDictionary else {
            throw FirestoreServiceError.getCollection
        }
        let path = FirestoreCollection.fcmToken.path

        try await firestoreService.createDocument(path, document: userUUID, data: data)
    }
}
