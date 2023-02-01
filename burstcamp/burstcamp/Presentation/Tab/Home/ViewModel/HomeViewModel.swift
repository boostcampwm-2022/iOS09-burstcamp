//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import BCFetcher

struct HomeFeedList: Equatable {
    let recommendFeed: [Feed]
    let normalFeed: [Feed]
}

final class HomeViewModel {

    var recommendFeedList: [Feed] = []
    var normalFeedList: [Feed] = []
    private var updateFeed: Feed?

    private var isFetching: Bool = false
    private var isLastFetch: Bool = false

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
        let recentHomeFeedList: AnyPublisher<HomeFeedList, Error>
        let paginateNormalFeedList: AnyPublisher<[Feed], Error>
    }

    struct CellOutput {
        let scrapSuccess: AnyPublisher<Feed?, Error>
    }

    func transform(input: Input) -> Output {
        let recentHomeFeedList = input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .tryMap {  _ in
                try self.fetchHomeFeedList()
                return HomeFeedList(
                    recommendFeed: self.recommendFeedList,
                    normalFeed: self.normalFeedList
                )
            }
            .eraseToAnyPublisher()

        let paginateNormalFeedList = input.pagination
            .tryMap { _ in
                try self.paginateNormalFeed()
                return self.normalFeedList
            }
            .eraseToAnyPublisher()

        return Output(
            recentHomeFeedList: recentHomeFeedList,
            paginateNormalFeedList: paginateNormalFeedList
        )
    }

    func transform(cellInput: CellInput, cellCancelBag: inout Set<AnyCancellable>) -> CellOutput {
        let scrapSuccess = cellInput.scrapButtonDidTap
            .tryMap { [weak self] normalFeedIndex in
                try self?.scrapFeed(index: normalFeedIndex)
                return self?.updateFeed
            }
            .eraseToAnyPublisher()

        return CellOutput(
            scrapSuccess: scrapSuccess
        )
    }

    private func fetchHomeFeedList() throws {
        Task { [weak self] in
            self?.isLastFetch = false
            if !isFetching {
                isFetching = true
                do {
                    let homeFeedList = try await self?.homeUseCase.fetchRecentHomeFeedList()
                    guard let homeFeedList = homeFeedList else {
                        debugPrint("homeFeedList 언래핑 에러")
                        return
                    }
                    self?.recommendFeedList = homeFeedList.recommendFeed
                    self?.normalFeedList = homeFeedList.normalFeed
                } catch {
                    throw HomeViewModelError.fetchHomeFeedList
                }
                isFetching = false
            }
        }
    }

    private func paginateNormalFeed() throws {
        Task { [weak self] in
            if !isFetching && !isLastFetch {
                isFetching = true
                do {
                    let normalFeed = try await self?.homeUseCase.fetchMoreNormalFeed()
                    guard let normalFeed = normalFeed else {
                        debugPrint("normalFeed 페이지네이션 언래핑 에러")
                        return
                    }
                    guard !normalFeed.isEmpty else {
                        isLastFetch = true
                        return
                    }
                    self?.normalFeedList.append(contentsOf: normalFeed)
                } catch {
                    throw error
                }
                isFetching = false
            }
        }
    }

    private func scrapFeed(index: Int) throws {
        if index < normalFeedList.count {
            let feed = normalFeedList[index]
            let userUUID = UserManager.shared.user.userUUID

            Task { [weak self] in
                guard let self = self else {
                    throw HomeViewModelError.feedUpdate
                }
                let updatedFeed = try await self.homeUseCase.scrapFeed(feed, userUUID: userUUID)
                self.updateFeed = updatedFeed
            }
        } else {
            throw HomeViewModelError.feedIndex
        }
    }
}

// MARK: - 홈 화면에서 알람 설정을 위한 인터페이스

extension HomeViewModel {
    func updateUserScrapState(to scrapState: Bool) throws  {
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
