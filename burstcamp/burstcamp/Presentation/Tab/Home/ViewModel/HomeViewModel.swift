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

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct Output {
        let recentFeed: AnyPublisher<HomeFeedList, Never>
        let moreFeed: AnyPublisher<[Feed], Never>
        let hideIndicator: AnyPublisher<Void, Never>
        let showAlert: AnyPublisher<Error, Never>
        let showToast: AnyPublisher<String, Never>
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

    func dequeueCellViewModel(at index: Int) -> ScrapViewModel {
        let scrapViewModel = ScrapViewModel(
            feedUUID: normalFeedData[index].feedUUID
        )
        return scrapViewModel
    }

    func fetchHomeFeedList() {
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

    func paginateNormalFeed() {
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
                        showToast.send("모든 피드를 불러왔습니다.")
                        isLastFetch = true
                    } else {
                        showAlert.send(error)
                    }
                }
                isFetching = false
            }
        }
    }
}
