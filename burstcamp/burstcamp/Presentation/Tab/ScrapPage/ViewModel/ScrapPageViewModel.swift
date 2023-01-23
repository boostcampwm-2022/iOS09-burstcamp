//
//  ScrapViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

import BCFetcher

typealias FeedWithOrder = (order: Int, feed: Feed)

final class ScrapPageViewModel {

    var scrapFeedList: [Feed] = []
    var isLastFetch: Bool = false
    var isFetching: Bool = false

    private let userUUID: String
    private let scrapPageUseCase: ScrapPageUseCase

    init(
        scrapPageUseCase: ScrapPageUseCase,
        userUUID: String = UserManager.shared.user.userUUID
    ) {
        self.scrapPageUseCase = scrapPageUseCase
        self.userUUID = userUUID
    }

    private let recentScrapFeed = CurrentValueSubject<[Feed]?, Never>(nil)
    private let moreFeed = CurrentValueSubject<[Feed]?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)
    private let showToast = CurrentValueSubject<String?, Never>(nil)

    private let scrapSuccess = CurrentValueSubject<Feed?, Never>(nil)

    private var cancelBag = Set<AnyCancellable>()

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct CellInput {
        let scrapButtonDidTap: AnyPublisher<Int, Never>
    }

    struct Output {
        let recentScrapFeed: AnyPublisher<[Feed], Never>
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
                self?.fetchRecentScrapFeed()
                self?.hideIndicator.send(Void())
            }
            .store(in: &cancelBag)

        input.pagination
            .sink { [weak self] _ in
                self?.paginateScrapFeed()
            }
            .store(in: &cancelBag)

        return Output(
            recentScrapFeed: recentScrapFeed.unwrap().eraseToAnyPublisher(),
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

    private func scrapFeed(index: Int) {
        if index < scrapFeedList.count {
            let feed = scrapFeedList[index]
            let userUUID = UserManager.shared.user.userUUID
            Task { [weak self] in
                guard let self = self else {
                    showAlert.send(HomeViewModelError.feedUpdate)
                    return
                }
                let updatedFeed = try await self.scrapPageUseCase.scrapFeed(feed, userUUID: userUUID)
                self.updateScrapFeed(updatedFeed)
                self.scrapSuccess.send(updatedFeed)
            }
        } else {
            showAlert.send(HomeViewModelError.feedIndex)
        }
    }

    private func fetchRecentScrapFeed() {
        Task { [weak self] in
            self?.isLastFetch = false
            if !isFetching {
                isFetching = true
                let scrapFeed = try await self?.scrapPageUseCase.fetchRecentScrapFeed()
                guard let scrapFeed = scrapFeed else {
                    debugPrint("scrapFeedList 언래핑 에러")
                    return
                }
                self?.scrapFeedList = scrapFeed
                self?.recentScrapFeed.send(scrapFeed)
                isFetching = false
            }
        }
    }

    private func paginateScrapFeed() {
        Task { [weak self] in
            if !isFetching && !isLastFetch {
                isFetching = true
                do {
                    let scrapFeed = try await self?.scrapPageUseCase.fetchMoreScrapFeed()
                    guard let scrapFeed = scrapFeed else {
                        debugPrint("normalFeed 페이지네이션 언래핑 에러")
                        return
                    }
                    self?.scrapFeedList.append(contentsOf: scrapFeed)
                    self?.moreFeed.send(scrapFeed)
                } catch {
                    if let error = error as? FirestoreServiceError, error == .lastFetch {
                        showToast.send("스크랩 피드를 모두 불러왔어요")
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

extension ScrapPageViewModel {
    func updateScrapFeed(_ updatedScrapFeed: Feed) {
        scrapFeedList = scrapFeedList.map { feed in
            return feed.feedUUID == updatedScrapFeed.feedUUID ? updatedScrapFeed : feed
        }
    }
}
