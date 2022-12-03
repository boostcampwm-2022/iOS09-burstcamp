//
//  ScrapViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import FirebaseFirestore

typealias FeedWithOrder = (order: Int, feed: Feed)

final class ScrapPageViewModel {

    var scarpFeedData: [Feed] = []
    private var willRequestFeedID: [String] = []
    var cancelBag = Set<AnyCancellable>()

    private let requestFeedNumber = 7
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
                self?.paginateFeed(output: output)
            }
            .store(in: &cancelBag)

        return output
    }

    private func getUserScarpUUID() -> [String] {
        return [
            "Test2", "Test4", "Test6", "Test8", "Test10",
                "Test3", "Test5", "Test7", "Test9", "Test11", "Feed1"
        ]
    }

    private func initScrapFeedUUID() {
        willRequestFeedID = getUserScarpUUID()
    }

    private func getLatestFeedUUID() -> [String] {
        var result: [String] = []
        for _ in 0..<requestFeedNumber {
            let feedUUID = willRequestFeedID.popLast()
            if let feedUUID = feedUUID {
                result.append(feedUUID)
            }
        }
        return result
    }

    private func fetchFeed(output: Output) {
        initScrapFeedUUID()
        Task {
            do {
                guard !isFetching else { return }
                isFetching = true
                canFetchMoreFeed = true

                let scrapFeeds = try await fetchFeedArray()
                scarpFeedData = scrapFeeds
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
                guard !willRequestFeedID.isEmpty else {
                    canFetchMoreFeed = false
                    return
                }
                isFetching = true
                canFetchMoreFeed = true

                let scrapFeeds = try await fetchFeedArray()
                scarpFeedData.append(contentsOf: scrapFeeds)
                output.fetchResult.send(.fetchSuccess)

                isFetching = false
            } catch {
            isFetching = false
            }
        }
    }

    private func fetchFeedArray() async throws -> [Feed] {
        try await withThrowingTaskGroup(of: FeedWithOrder.self, body: { taskGroup in
            let requestFeedUUIDs = getLatestFeedUUID()
            var scrapFeeds: [FeedWithOrder] = []

            requestFeedUUIDs.enumerated().forEach { index, feedUUID in
                taskGroup.addTask {
                    let feed = try await self.requestFeed(uuid: feedUUID)
                    return FeedWithOrder(order: index, feed: feed)
                }
            }

            for try await feed in taskGroup {
                scrapFeeds.append(feed)
            }

            let result = scrapFeeds
                .sorted { $0.order < $1.order }
                .map { $0.feed }

            return result
        })
    }

    private func requestFeed(uuid: String) async throws -> Feed {
        let feedDTO = try await requestFeedDTO(uuid: uuid)
        let feedWriter = try await requestFeedWriter(uuid: feedDTO.writerUUID)
        let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
        return feed
    }

    private func requestFeedDTO(uuid: String) async throws -> FeedDTO {
        try await withCheckedThrowingContinuation({ continuation in
            Firestore.firestore()
                .collection("Feed")
                .document(uuid)
                .getDocument { documentSnapShot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let snapShot = documentSnapShot,
                          let feedDTOData = snapShot.data()
                    else {
                        continuation.resume(throwing: FirebaseError.fetchUserError)
                        return
                    }
                    let feedDTO = FeedDTO(data: feedDTOData)
                    continuation.resume(returning: feedDTO)
                }
        })
    }

    private func requestFeedWriter(uuid: String) async throws -> FeedWriter {
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
                    let feedWriter = FeedWriter(data: userData)
                    continuation.resume(returning: feedWriter)
                }
        })
    }
}
