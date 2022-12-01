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

    let homeFireStore: HomeFireStore
    var recommendFeedData: [Feed] = []
    var normalFeedData: [Feed] = []
    var cancelBag = Set<AnyCancellable>()

    init(homeFireStore: HomeFireStore) {
        self.homeFireStore = homeFireStore
    }

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
                self?.fetchRecommendFeed()
                self?.fetchFeed(output: output)
            }
            .store(in: &cancelBag)

        input.viewRefresh
            .sink { [weak self] _ in
                self?.fetchFeed(output: output)
            }
            .store(in: &cancelBag)

        input.pagination
            .sink { [weak self] _ in
                self?.fetchFeed(output: output, isPagination: true)
            }
            .store(in: &cancelBag)

        return output
    }

    func fetchFeed(output: Output, isPagination: Bool = false) {
        homeFireStore.fetchFeed(isPagination: isPagination)
            .sink { completion in
                switch completion {
                case .finished:
                    output.fetchResult.send(.fetchSuccess)
                case .failure(let error):
                    output.fetchResult.send(.fetchFail(error: error))
                }
            } receiveValue: { [weak self] feeds in
                if isPagination {
                    self?.normalFeedData.append(contentsOf: feeds)
                } else {
                    self?.normalFeedData = feeds
                }
            }
            .store(in: &cancelBag)
    }

    func fetchRecommendFeed() {
        Task {
            let recommendFeed = try await fetchRecommendFeedArray()
            self.recommendFeedData = recommendFeed
            print(recommendFeed)
        }
    }

    func fetchRecommendFeedArray() async throws -> [Feed] {
        try await withThrowingTaskGroup(of: Feed.self, body: { taskGroup in
            var recommendFeeds: [Feed] = []
            let feedDTODictionary = try await self.requestRecommendFeeds()

            for feedDTO in feedDTODictionary {
                taskGroup.addTask {
                    let feedDTO = FeedDTO(data: feedDTO)
                    let feedWriterDictionary = try await self.requestFeedWriter(
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

    private func requestRecommendFeeds() async throws -> [[String: Any]] {
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

    private func requestFeedWriter(uuid: String) async throws -> [String: Any] {
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
