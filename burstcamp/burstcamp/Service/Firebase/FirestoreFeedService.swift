//
//  FirestoreFeed.swift
//  burstcamp
//
//  Created by youtak on 2022/12/07.
//

import Foundation

import FirebaseFirestore

protocol FirestoreFeedService {

    var lastSnapShot: QueryDocumentSnapshot? { get set }

    func createLatestQuery() -> Query
    func createPaginateQuery() -> Query?
    func fetchRecommendFeedDTOs() async throws -> [[String: Any]]
    func fetchLatestFeedDTOs() async throws -> [[String: Any]]
    func fetchMoreFeeds() async throws -> [[String: Any]]
    func fetchFeedDTO(feedUUID: String) async throws -> [String: Any]
    func fetchUser(userUUID: String) async throws -> [String: Any]
    func countFeedScarp(feedUUID: String) async throws -> Int
    func appendUserToFeed(userUUID: String, at feedUUID: String) async throws
    func deleteUserFromFeed(userUUID: String, at feedUUID: String) async throws
    func appendFeedUUIDToUser(feedUUID: String, at userUUID: String) async throws
    func deleteFeedUUIDFromUser(feedUUID: String, at userUUID: String) async throws
}

final class DefaultFirestoreFeedService: FirestoreFeedService {

    var lastSnapShot: QueryDocumentSnapshot?
    private let paginateCount = 7

    /// 최신 피드를 불러올 때 필요한 Query 생성
    /// - Returns: pubDate 기준으로 최신 Query
    /// @discussion
    ///
    func createLatestQuery() -> Query {
        return FirestoreCollection.feed.reference
            .order(by: "pubDate", descending: true)
            .limit(to: paginateCount)
    }

    /// 추가로 피드를 호출할 때 때 필요한 Query 생성
    /// - Returns: lastSnapShot 다음 Document부터의 Query
    /// @discussion
    /// 무한 스크롤을 위한 쿼리를 생성함.
    /// lastSnapShot이 nil 이면 마지막 피드까지 탐색한 것으로 더 이상 Query가 없기 때문에 nil을 리턴함
    func createPaginateQuery() -> Query? {
        guard let lastSnapShot = lastSnapShot
        else { return nil }

        return FirestoreCollection.feed.reference
            .order(by: "pubDate", descending: true)
            .limit(to: paginateCount)
            .start(afterDocument: lastSnapShot)
    }

    /// 추천 피드를 호출해서 2차원 딕셔너리로 리턴함
    /// - Returns: [[String: Any]] 타입 [Feed] 데이터
    /// @discussion
    /// Firestore - recommendFeed 컬렉션을 호출함
    func fetchRecommendFeedDTOs() async throws -> [[String: Any]] {
        try await withCheckedThrowingContinuation({ continuation in
            FirestoreCollection.recommendFeed.reference
                .getDocuments { querySnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let querySnapShot = querySnapShot else {
                        continuation.resume(throwing: FirebaseError.fetchRecommendFeedError)
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

    /// 최신 피드를 호출해서 2차원 딕셔너리로 리턴함
    /// - Returns: [[String: Any]] 타입 [Feed] 데이터
    /// @discussion
    /// Firestore - feed 컬렉션에서 pubDate 기준으로 paginateCount만큼 호출합니다.
    func fetchLatestFeedDTOs() async throws -> [[String: Any]] {
        try await withCheckedThrowingContinuation({ continuation in
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
                    self.lastSnapShot = querySnapShot.documents.last
                    if self.lastSnapShot == nil { // 응답한 Feed가 없는 경우
                        continuation.resume(throwing: FirebaseError.lastFetchError)
                        return
                    }

                    let normalFeeds = querySnapShot.documents.map { queryDocumentSnapshot in
                        let normalFeed = queryDocumentSnapshot.data()
                        return normalFeed
                    }
                    continuation.resume(returning: normalFeeds)
                }
        })
    }

    /// 최신 피드 이후에 추가적인 피드를 호출해서 2차원 딕셔너리로 리턴함
    /// - Returns: [[String: Any]] 타입 [Feed] 데이터
    /// @discussion
    /// fetchLatestFeedDTOs() 이후에 호출합니다.
    /// Firestore - feed 컬렉션에서  pubDate 기준으로 paginateCount만큼 추가 호출합니다.
    func fetchMoreFeeds() async throws -> [[String: Any]] {
        try await withCheckedThrowingContinuation({ continuation in
            guard let feedQuery = createPaginateQuery() else {
                continuation.resume(throwing: FirebaseError.paginateQueryError)
                return
            }

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

                    self.lastSnapShot = querySnapShot.documents.last
                    if self.lastSnapShot == nil { // 응답한 Feed가 없는 경우
                        continuation.resume(throwing: FirebaseError.lastFetchError)
                        return
                    }

                    let normalFeeds = querySnapShot.documents.map { queryDocumentSnapshot in
                        let normalFeed = queryDocumentSnapshot.data()
                        return normalFeed
                    }
                    continuation.resume(returning: normalFeeds)
                }
        })
    }

    /// firestore - feed 컬렉션에서 feed 1개를 호출함
    /// - Parameters:
    ///   - feedUUID: firestore에서 사용하는 feedUUID
    /// - Returns: [String: Any] 타입 Feed 데이터
    /// @discussion
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
                        continuation.resume(throwing: FirebaseError.fetchFeedError)
                        return
                    }
                    continuation.resume(returning: feedDTO)
                }
        })
    }

    /// firestore - user 컬렉션에서 user 1명을 호출함
    /// - Parameters:
    ///   - userUUID: firestore에서 사용하는 userUUID
    /// - Returns: [String: Any] 타입 User 데이터
    /// @discussion
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

    /// Firestore 스크랩 카운트를 호출해서 리턴함
    /// - Parameters:
    ///   - feedUUID: firestore에서 사용하는 feedUUID
    /// - Returns: 스크랩 카운트
    /// @discussion
    /// firestore - feed - `feedUUID` - scrapUser 의 카운트를 세서 리턴해준다.
    func countFeedScarp(feedUUID: String) async throws -> Int {
        let path = FirestoreCollection.scrapUser(feedUUID: feedUUID).path
        let countQuery = Firestore.firestore().collection(path).count
        let collectionCount = try await countQuery.getAggregation(source: .server)
        return Int(truncating: collectionCount.count)
    }

    /// 스크랩시 호출해서 Feed의 scrapUser에 User 데이터를 추가함
    /// - Parameters:
    ///   - userUUID: Feed - scrapUser에 추가할 userUUID
    ///   - feedUUID: user를 추가할 Feed의 UUID
    /// @discussion
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

    /// 스크랩 해제시 호출해서 Feed의 scrapUser에 User 데이터를 삭제함
    /// - Parameters:
    ///   - userUUID: Feed - scrapUser에서 삭제할 userUUID
    ///   - feedUUID: user를 삭제할 Feed의 UUID
    /// @discussion
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

    /// 스크랩시 호출해서 user의 scrapFeedUUIDs에 FeedUUID를 추가함
    /// - Parameters:
    ///   - feedUUID: user의  scrapFeedUUIDs에 추가할 Feed의 UUID
    ///   - userUUID: Feed를 추가할 user의 userUUID
    /// @discussion
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

    /// 스크랩 해제시 호출해서 user의 scrapFeedUUIDs에 FeedUUID를 삭제함
    /// - Parameters:
    ///   - feedUUID: user의  scrapFeedUUIDs에 삭제할 Feed의 UUID
    ///   - userUUID: Feed를 삭제할 user의 userUUID
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
