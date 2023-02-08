//
//  ScrapViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

typealias FeedWithOrder = (order: Int, feed: Feed)

final class ScrapPageViewModel {

    var scrapFeedList: [Feed] = []

    private let userUUID: String
    private let scrapPageUseCase: ScrapPageUseCase

    init(
        scrapPageUseCase: ScrapPageUseCase,
        userUUID: String = UserManager.shared.user.userUUID
    ) {
        self.scrapPageUseCase = scrapPageUseCase
        self.userUUID = userUUID
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
        let feedDeletePublisher: AnyPublisher<Feed, Never>
    }

    struct CellInput {
        let scrapButtonDidTap: AnyPublisher<String, Never>
    }

    struct Output {
        let recentScrapFeed: AnyPublisher<[Feed]?, Error>
        let paginateScrapFeed: AnyPublisher<[Feed]?, Error>
        let deleteFeed: AnyPublisher<Feed?, Never>
    }

    struct CellOutput {
        let scrapSuccess: AnyPublisher<Feed?, Error>
    }

    func transform(input: Input) -> Output {

        let recentScrapFeedPublisher = input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .asyncMap { [weak self] _ in
                try await self?.fetchRecentScrapFeed()
            }
            .eraseToAnyPublisher()

        let paginationPublisher = input.pagination
            .asyncMap { [weak self] _ in
                try await self?.paginateScrapFeed()
            }
            .eraseToAnyPublisher()

        let deleteFeed = input.feedDeletePublisher
            .map { [weak self] feed in
                self?.deleteFeedFromList(feed)
            }
            .eraseToAnyPublisher()

        return Output(
            recentScrapFeed: recentScrapFeedPublisher,
            paginateScrapFeed: paginationPublisher,
            deleteFeed: deleteFeed
        )
    }

    func transform(cellInput: CellInput) -> CellOutput {
        let scrapSuccessPublisher = cellInput.scrapButtonDidTap
            .asyncMap { [weak self] feedUUID in
                try await self?.scrapFeed(feedUUID: feedUUID)
            }
            .eraseToAnyPublisher()

        return CellOutput(
            scrapSuccess: scrapSuccessPublisher
        )
    }

    private func scrapFeed(feedUUID: String) async throws -> Feed {
        guard let feed = scrapFeedList.first(where: { $0.feedUUID == feedUUID }) else {
            throw ScrapPageViewModelError.scrapFeed
        }
        let userUUID = UserManager.shared.user.userUUID
        return try await self.scrapPageUseCase.scrapFeed(feed, userUUID: userUUID)
        }

    private func fetchRecentScrapFeed() async throws -> [Feed] {
        let scrapFeed = try await scrapPageUseCase.fetchRecentScrapFeed()
        scrapFeedList = scrapFeed
        return scrapFeed
    }

    private func paginateScrapFeed() async throws -> [Feed] {
        let scrapFeed = try await scrapPageUseCase.fetchMoreScrapFeed()
        scrapFeedList.append(contentsOf: scrapFeed)
        return scrapFeed
    }

    private func deleteFeedFromList(_ feed: Feed) -> Feed {
        scrapFeedList = scrapFeedList.filter { $0 != feed }
        return feed
    }
}

extension ScrapPageViewModel {
    func updateScrapFeed(_ updatedScrapFeed: Feed) -> [Feed] {
        scrapFeedList = scrapFeedList.map { feed in
            return feed.feedUUID == updatedScrapFeed.feedUUID ? updatedScrapFeed : feed
        }
        return scrapFeedList
    }

    func getCount() -> Int {
        return scrapFeedList.count
    }
}
