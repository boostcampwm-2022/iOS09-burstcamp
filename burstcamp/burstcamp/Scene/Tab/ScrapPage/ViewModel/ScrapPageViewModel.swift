//
//  ScrapViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import FirebaseFirestore

final class ScrapPageViewModel {

    var scarpFeedData: [Feed] = []
    private var willRequestFeedID: [String] = []
    var cancelBag = Set<AnyCancellable>()

    private let requestFeedNumber = 5
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

    private func fetchFeed(output: Output) {
        initScrapFeedUUID()
        Task { [weak self] in
            for _ in 0..<requestFeedNumber {
                let feedUUID = willRequestFeedID.popLast()
                guard let feedUUID = feedUUID else { return }
                let feed = try await requestFeed(uuid: feedUUID)
                print(feed)
                self?.scarpFeedData.append(feed)
            }
            output.fetchResult.send(.fetchSuccess)
        }
    }

    private func fetchWriter() {
    }

    private func paginateFeed(output: Output) {
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
