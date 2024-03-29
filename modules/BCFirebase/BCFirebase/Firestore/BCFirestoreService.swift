//
//  BCFirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

public protocol BCFirestoreServiceProtocol {
    func fetchRecommendFeed() async throws -> [FeedAPIModel]
    func fetchLatestNormalFeeds() async throws -> [FeedAPIModel]
    func fetchMoreNormalFeeds() async throws -> [FeedAPIModel]

    func fetchLatestScrapFeeds(userUUID: String) async throws -> [FeedAPIModel]
    func fetchMoreScrapFeeds(userUUID: String) async throws -> [FeedAPIModel]

    func fetchFeed(feedUUID: String) async throws -> FeedAPIModel

    func fetchUser(userUUID: String) async throws -> UserAPIModel
    func saveUser(userUUID: String, user: UserAPIModel) async throws
    func updateUser(userUUID: String, user: UserAPIModel) async throws
    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws
    func deleteUser(userUUID: String) async throws
    func isExistNickname(_ nickname: String) async throws -> Bool

    func scrapFeed(_ feed: ScrapFeedAPIModel, with userUUID: String) async throws
    func unScrapFeed(_ feed: FeedAPIModel, with userUUID: String) async throws
    func saveFCMToken(_ fcmToken: String, to userUUID: String) async throws
    
    func reportFeed(_ feedUUID: String, with userUUID: String) async throws
    func blockFeed(_ feed: FeedAPIModel, with userUUID: String, wasScraped: Bool) async throws
}

public final class BCFirestoreService: BCFirestoreServiceProtocol {

    private let firestoreService: FirestoreService
    private var homeLastSnapshot: QueryDocumentSnapshot?
    private var scrapPageLastSnapshot: QueryDocumentSnapshot?

    private let paginateCount: Int

    private var homeFeedQuery: Query {
        return firestoreService.createPaginateQuery(
            FirestoreCollection.normalFeed.path,
            field: "pubDate",
            count: paginateCount,
            lastSnapShot: homeLastSnapshot
        )
    }

    private func scrapPageFeedQuery(userUUID: String) -> Query {
        return firestoreService.createPaginateQuery(
            FirestoreCollection.scrapFeeds(userUUID: userUUID).path,
            field: "scrapDate",
            count: paginateCount,
            lastSnapShot: scrapPageLastSnapshot
        )
    }

    public init(firestoreService: FirestoreService, paginateCount: Int) {
        self.firestoreService = firestoreService
        self.paginateCount = paginateCount
    }

    public convenience init(paginateCount: Int = 10) {
        let firestoreService = FirestoreService()
        self.init(firestoreService: firestoreService, paginateCount: paginateCount)
    }

    private func initHomeFeedQuery() {
        self.homeLastSnapshot = nil
    }

    private func initScrapPageFeedQuery() {
        self.scrapPageLastSnapshot = nil
    }

    // MARK: - Home 피드 요청
    public func fetchRecommendFeed() async throws -> [FeedAPIModel] {
        let recommendFeedPath = FirestoreCollection.recommendFeed.path
        let feedFirestoreData = try await firestoreService.getCollection(recommendFeedPath)
        return feedFirestoreData.map { FeedAPIModel(data: $0) }
    }

    public func fetchLatestNormalFeeds() async throws -> [FeedAPIModel] {
        initHomeFeedQuery()
        let result = try await firestoreService.getCollection(query: homeFeedQuery)
        self.homeLastSnapshot = result.lastSnapshot
        if self.homeLastSnapshot == nil {
            throw FirestoreServiceError.lastFetch
        }

        return result.collectionData.map { FeedAPIModel(data: $0) }
    }

    public func fetchMoreNormalFeeds() async throws -> [FeedAPIModel] {
        let result = try await firestoreService.getCollection(query: homeFeedQuery)
        self.homeLastSnapshot = result.lastSnapshot
        if self.homeLastSnapshot == nil {
            throw FirestoreServiceError.lastFetch
        }

        return result.collectionData.map { FeedAPIModel(data: $0) }
    }

    // MARK: - Scrap Page Feed 요청
    public func fetchLatestScrapFeeds(userUUID: String) async throws -> [FeedAPIModel] {
        initScrapPageFeedQuery()
        let query = scrapPageFeedQuery(userUUID: userUUID)

        let result = try await firestoreService.getCollection(query: query)
        self.scrapPageLastSnapshot = result.lastSnapshot
        if result.collectionData.isEmpty {
            throw FirestoreServiceError.scrapIsEmpty
        }

        if self.scrapPageLastSnapshot == nil {
            throw FirestoreServiceError.lastFetch
        }

        return result.collectionData.map { FeedAPIModel(data: $0) }
    }

    public func fetchMoreScrapFeeds(userUUID: String) async throws -> [FeedAPIModel] {
        let query = scrapPageFeedQuery(userUUID: userUUID)

        let result = try await firestoreService.getCollection(query: query)
        self.scrapPageLastSnapshot = result.lastSnapshot
        if self.scrapPageLastSnapshot == nil {
            throw FirestoreServiceError.lastFetch
        }

        return result.collectionData.map { FeedAPIModel(data: $0) }
    }

    // MARK: - 단일 피드

    public func fetchFeed(feedUUID: String) async throws -> FeedAPIModel {
        let feedPath = FirestoreCollection.normalFeed.path
        let feedFirestoreData = try await firestoreService.getDocument(feedPath, document: feedUUID)

        return FeedAPIModel(data: feedFirestoreData)
    }

    // MARK: - 유저

    public func fetchUser(userUUID: String) async throws -> UserAPIModel {
        let userPath = FirestoreCollection.user.path
        let userFirestoreData = try await firestoreService.getDocument(userPath, document: userUUID)

        return UserAPIModel(data: userFirestoreData)
    }

    public func saveUser(userUUID: String, user: UserAPIModel) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.createDocument(userPath, document: userUUID, data: user.toFirestoreData())
    }

    public func updateUser(userUUID: String, user: UserAPIModel) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.updateDocument(userPath, document: userUUID, data: user.toFirestoreData())
    }

    public func updateUserPushState(userUUID: String, isPushOn: Bool) async throws {
        let userPath = FirestoreCollection.user.path

        try await firestoreService.updateDocument(userPath, document: userUUID, data: ["isPushOn": isPushOn])
    }

    public func deleteUser(userUUID: String) async throws {
        let userPath = FirestoreCollection.user.path
        try await firestoreService.deleteDocument(userPath, document: userUUID)
    }

    public func isExistNickname(_ nickname: String) async throws -> Bool {
        let userPath = FirestoreCollection.user.path
        let sameNicknameUser = try await firestoreService.getDocument(userPath, field: "nickname", isEqualTo: nickname)
        if sameNicknameUser.first != nil {
            return true
        }
        return false
    }

    // MARK: - 피드 스크랩

    public func scrapFeed(_ feed: ScrapFeedAPIModel, with userUUID: String) async throws {
        let batch = firestoreService.getDatabaseBatch()
        let feedUUID = feed.feedUUID

        // feed - scrapUser에 userUUID 추가
        let scrapUserPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
            document: userUUID
        )
        let scrapUserData: [String: Any] = [
            "userUUID": userUUID,
            "scrapDate": feed.scrapDate
        ]
        batch.setData(scrapUserData, forDocument: scrapUserPath)

        // user - scrapFeedUUIDs 배열에 feedUUID 추가
        let userPath = firestoreService.getDocumentPath(collection: FirestoreCollection.user.path, document: userUUID)
        batch.updateData([FirestoreCollection.scrapFeedUUIDs: FieldValue.arrayUnion([feedUUID])], forDocument: userPath)

        // user - feed 컬렉션에 feed 데이터 추가
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
        batch.updateData(["scrapCount": feed.scrapCount], forDocument: feedPath)

        try await batch.commit()
    }

    public func unScrapFeed(_ feed: FeedAPIModel, with userUUID: String) async throws {
        let batch = firestoreService.getDatabaseBatch()
        let feedUUID = feed.feedUUID

        // feed - scrapUser에 userUUID 삭제
        let scrapUserPath = firestoreService.getDocumentPath(
            collection: FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
            document: userUUID
        )
        batch.deleteDocument(scrapUserPath)

        // user - scrapFeedUUIDs 배열에 feedUUID 추가
        let userPath = firestoreService.getDocumentPath(collection: FirestoreCollection.user.path, document: userUUID)
        batch.updateData([FirestoreCollection.scrapFeedUUIDs: FieldValue.arrayRemove([feedUUID])], forDocument: userPath)

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
        batch.updateData(["scrapCount": feed.scrapCount], forDocument: feedPath)

        try await batch.commit()
    }

    // MARK: 토큰 저장

    public func saveFCMToken(_ fcmToken: String, to userUUID: String) async throws {
        let fcmToken = FCMToken(fcmToken: fcmToken)
        guard let data = fcmToken.asDictionary else {
            throw FirestoreServiceError.getCollection
        }
        let path = FirestoreCollection.fcmToken.path

        try await firestoreService.createDocument(path, document: userUUID, data: data)
    }
    
    // MARK: 피드 신고

    public func reportFeed(_ feedUUID: String, with userUUID: String) async throws {
        let reportFeedPath = FirestoreCollection.reportFeed.path

        try await firestoreService.createDocument(
            reportFeedPath,
            document: feedUUID,
            data: [
                "userUUID": userUUID,
                "reportDate": Date()
            ]
        )
    }

    // MARK: 피드 차단
    
    public func blockFeed(_ feed: FeedAPIModel, with userUUID: String, wasScraped: Bool) async throws {
        let batch = firestoreService.getDatabaseBatch()
        let feedUUID = feed.feedUUID

        if wasScraped { // 기존에 스크랩 피드라면
            // feed - scrapUser에 userUUID 삭제
            let scrapUserPath = firestoreService.getDocumentPath(
                collection: FirestoreCollection.scrapUsers(feedUUID: feedUUID).path,
                document: userUUID
            )
            batch.deleteDocument(scrapUserPath)

            // user - scrapFeedUUIDs 배열에 feedUUID 삭제
            let userPath = firestoreService.getDocumentPath(collection: FirestoreCollection.user.path, document: userUUID)
            batch.updateData([FirestoreCollection.scrapFeedUUIDs: FieldValue.arrayRemove([feedUUID])], forDocument: userPath)

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
            batch.updateData(["scrapCount": feed.scrapCount], forDocument: feedPath)
            // user - scrapFeed에서 삭제
        }
        
        // user - reportFeedUUID 배열에 feedUUID 추가
        let userPath = firestoreService.getDocumentPath(collection: FirestoreCollection.user.path, document: userUUID)
        batch.updateData([FirestoreCollection.reportFeedUUIDs: FieldValue.arrayUnion([feedUUID])], forDocument: userPath)

        try await batch.commit()
    }
}
