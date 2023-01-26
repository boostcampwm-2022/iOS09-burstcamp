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

    var recommendFeedData: [Feed] = []
    var normalFeedData: [Feed] = []

    private var isFetching: Bool = false
    private var isLastFetch: Bool = false

    private var cancelBag = Set<AnyCancellable>()

    private let homeUseCase: HomeUseCase

    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }

    private let recentFeed = CurrentValueSubject<HomeFeedList?, Never>(nil)
    private let moreFeed = CurrentValueSubject<[Feed]?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)
    private let showToast = CurrentValueSubject<String?, Never>(nil)

    private let scrapSuccess = CurrentValueSubject<Feed?, Never>(nil)

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct CellInput {
        let scrapButtonDidTap: AnyPublisher<Int, Never>
    }

    struct Output {
        let recentFeed: AnyPublisher<HomeFeedList, Never>
        let moreFeed: AnyPublisher<[Feed], Never>
        let hideIndicator: AnyPublisher<Void, Never>
        let showAlert: AnyPublisher<Error, Never>
        let showToast: AnyPublisher<String, Never>
    }

    struct CellOutput {
        let scrapSuccess: AnyPublisher<Feed, Never>
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .sink { [weak self] _ in
                self?.fetchHomeFeedList()
                self?.hideIndicator.send(Void())
            }
            .store(in: &cancelBag)

        input.pagination
            .sink { [weak self] _ in
                self?.paginateNormalFeed()
            }
            .store(in: &cancelBag)

        return Output(
            recentFeed: recentFeed.unwrap().eraseToAnyPublisher(),
            moreFeed: moreFeed.unwrap().eraseToAnyPublisher(),
            hideIndicator: hideIndicator.unwrap().eraseToAnyPublisher(),
            showAlert: showAlert.unwrap().eraseToAnyPublisher(),
            showToast: showToast.unwrap().eraseToAnyPublisher()
        )
    }

    func transform(cellInput: CellInput, cellCancelBag: inout Set<AnyCancellable>) -> CellOutput {
        cellInput.scrapButtonDidTap
            .sink { [weak self] normalFeedIndex in
                self?.scrapFeed(index: normalFeedIndex)
            }
            .store(in: &cellCancelBag)

        return CellOutput(
            scrapSuccess: scrapSuccess.unwrap().eraseToAnyPublisher()
        )
    }

    private func fetchHomeFeedList() {
        Task { [weak self] in
            self?.isLastFetch = false
            if !isFetching {
                isFetching = true
                let homeFeedList = try await self?.homeUseCase.fetchRecentHomeFeedList()
                guard let homeFeedList = homeFeedList else {
                    debugPrint("homeFeedList 언래핑 에러")
                    return
                }
                self?.recommendFeedData = homeFeedList.recommendFeed
                self?.normalFeedData = homeFeedList.normalFeed
                self?.recentFeed.send(homeFeedList)
                isFetching = false
            }
        }
    }

    private func paginateNormalFeed() {
        Task { [weak self] in
            if !isFetching && !isLastFetch {
                isFetching = true
                do {
                    let normalFeed = try await self?.homeUseCase.fetchMoreNormalFeed()
                    guard let normalFeed = normalFeed else {
                        debugPrint("normalFeed 페이지네이션 언래핑 에러")
                        return
                    }
                    self?.normalFeedData.append(contentsOf: normalFeed)
                    self?.moreFeed.send(normalFeed)
                } catch {
                    if let error = error as? FirestoreServiceError, error == .lastFetch {
                        showToast.send("모든 피드를 불러왔어요")
                        isLastFetch = true
                    } else {
                        showAlert.send(error)
                    }
                }
                isFetching = false
            }
        }
    }

    private func scrapFeed(index: Int) {
        if index < normalFeedData.count {
            let feed = normalFeedData[index]
            let userUUID = UserManager.shared.user.userUUID
            Task { [weak self] in
                guard let self = self else {
                    showAlert.send(HomeViewModelError.feedUpdate)
                    return
                }
                let updatedFeed = try await self.homeUseCase.scrapFeed(feed, userUUID: userUUID)
                _ = self.updateNormalFeed(updatedFeed)
                self.scrapSuccess.send(updatedFeed)
            }
        } else {
            showAlert.send(HomeViewModelError.feedIndex)
        }
    }
}

extension HomeViewModel {
    func updateUserScrapState(to scrapState: Bool) {
        Task { [weak self] in
            do {
                try await self?.homeUseCase.updateUserPushState(to: scrapState)
            } catch {
                showAlert.send(HomeViewModelError.pushState)
            }
        }
    }
}

// FeedDetail에서 변경된 Feed 업데이트
extension HomeViewModel {
    func updateNormalFeed(_ updatedFeed: Feed) -> [Feed] {
        normalFeedData = normalFeedData.map { feed in
            if feed.feedUUID == updatedFeed.feedUUID {
                return updatedFeed
            } else {
                return feed
            }
        }
        return normalFeedData
    }
}
