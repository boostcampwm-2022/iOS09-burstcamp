//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import FirebaseFirestore

final class HomeViewModel {

    var recommendFeedData: [Feed] = []
    var normalFeedData: [Feed] = []
    var cancelBag = Set<AnyCancellable>()

    private var lastSnapShot: QueryDocumentSnapshot?
    private var isFetching: Bool = false
    private var canFetchMoreFeed: Bool = true

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewRefresh: AnyPublisher<Bool, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    enum FetchResult {
        case fetchFail(error: Error)
        case fetchSuccess
    }

    struct Output {
        var fetchResult = PassthroughSubject<FetchResult, Never>()
    }

    func transform(input: Input) -> Output {
        let output = Output()

        input.viewDidLoad
            .sink { [weak self] _ in
                self?.fetchAllFeed(output: output)
            }
            .store(in: &cancelBag)

        input.viewRefresh
            .sink { [weak self] _ in
                self?.fetchAllFeed(output: output)
            }
            .store(in: &cancelBag)

        input.pagination
            .sink { [weak self] _ in
                self?.paginateFeed(output: output)
            }
            .store(in: &cancelBag)

        return output
    }

    private func fetchAllFeed(output: Output) {
        Task {
            do {
                guard !isFetching else { return }
                isFetching = true
                canFetchMoreFeed = true

                async let recommendFeeds = fetchRecommendFeeds()
                async let normalFeeds = fetchNormalFeeds(lastSnapShot: self.lastSnapShot)
                self.recommendFeedData = try await recommendFeeds
                self.normalFeedData = try await normalFeeds
                output.fetchResult.send(.fetchSuccess)

                isFetching = false
            } catch {
                isFetching = false
            }
        }
    }

    private func paginateFeed(output: Output) {
        Task {
            do {
                guard !isFetching, canFetchMoreFeed else { return }
                isFetching = true

                let normalFeeds = try await fetchNormalFeeds(
                    lastSnapShot: self.lastSnapShot,
                    isPagination: true
                )
                self.normalFeedData.append(contentsOf: normalFeeds)
                output.fetchResult.send(.fetchSuccess)

                isFetching = false
            } catch {
                canFetchMoreFeed = false
                isFetching = false
            }
        }
    }

    private func fetchNormalFeeds(
        lastSnapShot: QueryDocumentSnapshot?,
        isPagination: Bool = false
    ) async throws -> [Feed] {
        try await withThrowingTaskGroup(of: Feed.self, body: { taskGroup in
            var normalFeeds: [Feed] = []
            let feedDTODictionary = try await self.fetchNormalFeeds(
                lastSnapShot: lastSnapShot,
                isPagination: isPagination
            )

            for feedDTO in feedDTODictionary {
                taskGroup.addTask {
                    let feedDTO = FeedDTO(data: feedDTO)
                    let feedWriterDictionary = try await self.fetchFeedWriter(
                        uuid: feedDTO.writerUUID
                    )
                    let feedWriter = FeedWriter(data: feedWriterDictionary)
                    let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                    return feed
                }
            }

            for try await feed in taskGroup {
                normalFeeds.append(feed)
            }

            let result = normalFeeds.sorted { $0.pubDate > $1.pubDate }

            return result
        })
    }

    private func fetchNormalFeedDTOs(
        lastSnapShot: QueryDocumentSnapshot?,
        isPagination: Bool
    ) async throws -> [[String: Any]] {
        try await withCheckedThrowingContinuation({ continuation in
            let feedQuery = createQuery(lastSnapShot: lastSnapShot, isPagination: isPagination)

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

    private func createQuery(lastSnapShot: QueryDocumentSnapshot?, isPagination: Bool) -> Query {
        if let lastSnapShot = lastSnapShot, isPagination {
            return Firestore.firestore()
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .limit(to: 5)
                .start(afterDocument: lastSnapShot)
        } else {
            return Firestore.firestore()
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .limit(to: 5)
        }
    }

    private func fetchRecommendFeeds() async throws -> [Feed] {
        try await withThrowingTaskGroup(of: Feed.self, body: { taskGroup in
            var recommendFeeds: [Feed] = []
            let feedDTODictionary = try await self.fetchRecommendFeedDTOs()

            for feedDTO in feedDTODictionary {
                taskGroup.addTask {
                    let feedDTO = FeedDTO(data: feedDTO)
                    let feedWriterDictionary = try await self.fetchFeedWriter(
                        uuid: feedDTO.writerUUID
                    )
                    let feedWriter = FeedWriter(data: feedWriterDictionary)
                    let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                    return feed
                }
            }

            for try await feed in taskGroup {
                recommendFeeds.append(feed)
            }

            return recommendFeeds
        })
    }

    private func fetchRecommendFeedDTOs() async throws -> [[String: Any]] {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("RecommendFeed")
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

    private func fetchFeedWriter(uuid: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("User")
                .document(uuid)
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
}
