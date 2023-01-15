//
//  BCFirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

protocol BCFirestoreServiceProtocol {
    func fetchRecommendFeed() async throws -> [FeedAPIModel]
    func fetchLatestNormalFeeds() async throws -> [FeedAPIModel]
    func fetchMoreNormalFeeds() async throws -> [FeedAPIModel]
    func fetchFeed(feedUUID: String) async throws -> FeedAPIModel
    func fetchUser(userUUID: String) async throws -> UserAPIModel
    func saveUser(userUUID: String, user: UserAPIModel) async throws
    func updateUser(userUUID: String, user: UserAPIModel) async throws
    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws
    func deleteUser(userUUID: String) async throws
    func addListenerToUser(userUUID: String) async throws -> UserAPIModel
    func countFeedScrap(feedUUID: String) async throws -> Int
    func scrapFeed(_ feed: FeedAPIModel, with userUUID: String) async throws
    func unScrapFeed(_ feed: FeedAPIModel, with userUUID: String) async throws
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

    func fetchRecommendFeed() async throws -> [FeedAPIModel] {
        let recommendFeedPath = FirestoreCollection.recommendFeed.path
        let feedFirestoreData = try await firestoreService.getCollection(recommendFeedPath)
        return feedFirestoreData.map { FeedAPIModel(data: $0) }
    }

    func fetchLatestNormalFeeds() async throws -> [FeedAPIModel] {
        initFeedQuery()
        let result = try await firestoreService.getCollection(query: feedQuery)
        self.lastSnapShot = result.lastSnapshot

        return result.collectionData.map { FeedAPIModel(data: $0) }
    }

    func fetchMoreNormalFeeds() async throws -> [FeedAPIModel] {
        let result = try await firestoreService.getCollection(query: feedQuery)
        self.lastSnapShot = result.lastSnapshot

        return result.collectionData.map { FeedAPIModel(data: $0) }
    }

    func fetchFeed(feedUUID: String) async throws -> FeedAPIModel {
        let feedPath = FirestoreCollection.normalFeed.path
        let feedFirestoreData = try await firestoreService.getDocument(feedPath, document: feedUUID)

        return FeedAPIModel(data: feedFirestoreData)
    }

    func fetchUser(userUUID: String) async throws -> UserAPIModel {
        let userPath = FirestoreCollection.user.path
        let userFirestoreData = try await firestoreService.getDocument(userPath, document: userUUID)

        return UserAPIModel(data: userFirestoreData)
    }

    func saveUser(userUUID: String, user: UserAPIModel) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.createDocument(userPath, document: userUUID, data: user.toFirestoreData())
    }

    func updateUser(userUUID: String, user: UserAPIModel) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.updateDocument(userPath, document: userUUID, data: user.toFirestoreData())
    }

    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws {
        let userPath = FirestoreCollection.user.path

        try await firestoreService.updateDocument(userPath, document: userUUID, data: ["isPushOnField": isPushOn])
    }

    func deleteUser(userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.deleteDocument(userPath, document: userUUID)
    }

    func addListenerToUser(userUUID: String) async throws -> UserAPIModel {
        let userPath = FirestoreCollection.user.path
        let userData = try await firestoreService.addListenerToDocument(userPath, document: userUUID)

        return UserAPIModel(data: userData)
    }

    func countFeedScrap(feedUUID: String) async throws -> Int {
        let scrapUsersPath = FirestoreCollection.scrapUsers(feedUUID: feedUUID).path
        let scrapCount = try await firestoreService.countCollection(scrapUsersPath)

        return scrapCount
    }

    func scrapFeed(_ feed: FeedAPIModel, with userUUID: String) async throws {
        let batch = firestoreService.getDatabaseBatch()
        let feedUUID = feed.feedUUID

        // feed - scrapUser에 userUUID 추가
        let scrapUserPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
            document: userUUID
        )
        let scrapUserData: [String: Any] = [
            "userUUID": userUUID,
            "scrapDate": Timestamp(date: Date())
        ]
        batch.setData(scrapUserData, forDocument: scrapUserPath)

        // user - feed에 feed 데이터 추가
        let scrapFeedPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.scrapFeeds(userUUID: userUUID).path,
            document: feedUUID
        )
        batch.setData(feed.toScrapFirestoreData(), forDocument: scrapFeedPath)

        // feed - scrapCount+1
        let feedPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.normalFeed.path,
            document: feedUUID
        )
        batch.updateData(["scrapCount": feed.scrapCount + 1], forDocument: feedPath)

        try await batch.commit()
    }

    func unScrapFeed(_ feed: FeedAPIModel, with userUUID: String) async throws {
        let batch = firestoreService.getDatabaseBatch()
        let feedUUID = feed.feedUUID

        // feed - scrapUser에 userUUID 삭제
        let scrapUserPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
            document: userUUID
        )
        batch.deleteDocument(scrapUserPath)

        // user - feed에 feed 데이터 삭제
        let scrapFeedPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.scrapFeeds(userUUID: userUUID).path,
            document: feedUUID
        )
        batch.deleteDocument(scrapFeedPath)

        // feed - scrapCount-1
        let feedPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.normalFeed.path,
            document: feedUUID
        )
        batch.updateData(["scrapCount": feed.scrapCount - 1], forDocument: feedPath)

        try await batch.commit()
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
