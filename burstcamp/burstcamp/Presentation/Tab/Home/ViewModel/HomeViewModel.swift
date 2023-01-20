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

    private var cancelBag = Set<AnyCancellable>()

    private let homeUseCase: HomeUseCase

    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }

    private let recentFeed = CurrentValueSubject<HomeFeedList?, Never>(nil)
    private let moreFeed = CurrentValueSubject<[Feed]?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

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
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .merge(with: input.viewDidRefresh)
            .sink { [weak self] _ in
                self?.fetchHomeFeedList()
            }
            .store(in: &cancelBag)

        return Output(
            recentFeed: recentFeed.unwrap().eraseToAnyPublisher(),
            moreFeed: moreFeed.unwrap().eraseToAnyPublisher(),
            hideIndicator: hideIndicator.unwrap().eraseToAnyPublisher(),
            showAlert: showAlert.unwrap().eraseToAnyPublisher()
        )
    }

    func dequeueCellViewModel(at index: Int) -> ScrapViewModel {
        let scrapViewModel = ScrapViewModel(
            feedUUID: normalFeedData[index].feedUUID,
            feedLocalDataSource: FeedRealmDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
        return scrapViewModel
    }

    func fetchHomeFeedList() {
        Task { [weak self] in
            let homeFeedList = try await self?.homeUseCase.fetchRecentHomeFeedList()
            guard let homeFeedList = homeFeedList else {
                debugPrint("homeFeedList")
                return
            }
            self?.recommendFeedData = homeFeedList.recommendFeed
            self?.normalFeedData = homeFeedList.normalFeed
            self?.recentFeed.send(homeFeedList)
        }
    }
}
