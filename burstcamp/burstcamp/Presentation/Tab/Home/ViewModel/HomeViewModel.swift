//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

struct HomeFeedList: Equatable {
    let recommendFeed: [Feed]
    let normalFeed: [Feed]
}

final class HomeViewModel {

    var recommendFeedList: [Feed] = []
    var normalFeedList: [Feed] = []

    private let homeUseCase: HomeUseCase

    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct CellInput {
        let scrapButtonDidTap: AnyPublisher<Int, Never>
    }

    struct Output {
        let recentHomeFeedList: AnyPublisher<HomeFeedList?, Error>
        let paginateNormalFeedList: AnyPublisher<[Feed]?, Error>
    }

    struct CellOutput {
        let scrapSuccess: AnyPublisher<Feed?, Error>
    }

    func transform(input: Input) -> Output {
        let recentHomeFeedList = input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .asyncMap { [weak self] _ in
                return try await self?.fetchHomeFeedList()
            }
            .eraseToAnyPublisher()

        let paginateNormalFeedList = input.pagination
            .asyncMap { [weak self] _ in
                return try await self?.paginateNormalFeed()
            }
            .eraseToAnyPublisher()

        return Output(
            recentHomeFeedList: recentHomeFeedList,
            paginateNormalFeedList: paginateNormalFeedList
        )
    }

    func transform(cellInput: CellInput, cellCancelBag: inout Set<AnyCancellable>) -> CellOutput {
        let scrapSuccess = cellInput.scrapButtonDidTap
            .asyncMap { [weak self] normalFeedIndex in
                return try await self?.scrapFeed(index: normalFeedIndex)
            }
            .eraseToAnyPublisher()

        return CellOutput(
            scrapSuccess: scrapSuccess
        )
    }

    private func fetchHomeFeedList() async throws -> HomeFeedList {
        do {
            let homeFeedList = try await homeUseCase.fetchRecentHomeFeedList()
            self.recommendFeedList = homeFeedList.recommendFeed
            self.normalFeedList = homeFeedList.normalFeed
            return homeFeedList
        } catch {
            throw HomeViewModelError.fetchHomeFeedList
        }
    }

    private func paginateNormalFeed() async throws -> [Feed] {
        do {
            let normalFeed = try await homeUseCase.fetchMoreNormalFeed()
            guard !normalFeed.isEmpty else {
                return []
            }
            normalFeedList.append(contentsOf: normalFeed)
            return normalFeed
        } catch {
            throw error
        }
    }

    private func scrapFeed(index: Int) async throws -> Feed {
        if index < normalFeedList.count {
            let feed = normalFeedList[index]
            let userUUID = UserManager.shared.user.userUUID
            let updatedFeed = try await homeUseCase.scrapFeed(feed, userUUID: userUUID)
            return updatedFeed
        } else {
            throw HomeViewModelError.feedIndex
        }
    }
}

// MARK: - 홈 화면에서 알람 설정을 위한 인터페이스

extension HomeViewModel {
    func updateUserScrapState(to scrapState: Bool) throws {
        Task { [weak self] in
            do {
                try await self?.homeUseCase.updateUserPushState(to: scrapState)
            } catch {
                throw HomeViewModelError.pushState
            }
        }
    }
}

// MARK: - FeedDetail에서 변경된 Feed 업데이트

extension HomeViewModel {
    func updateNormalFeed(_ updatedFeed: Feed) -> [Feed] {
        normalFeedList = normalFeedList.map { feed in
            if feed.feedUUID == updatedFeed.feedUUID {
                return updatedFeed
            } else {
                return feed
            }
        }
        return normalFeedList
    }
}
