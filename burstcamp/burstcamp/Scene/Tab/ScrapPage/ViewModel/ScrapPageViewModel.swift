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

    var scrapFeedData: [Feed] = []

    private var cancelBag = Set<AnyCancellable>()
    private var temporaryCancelBag = Set<AnyCancellable>()

    private let userUUID: String
    private let localDataSource: FeedLocalDataSource
    private let remoteDataSource: FeedRemoteDataSource
    private let fetcher: Fetcher<[Feed], Error>

    init(
        userUUID: String = UserManager.shared.user.userUUID,
        localDataSource: FeedLocalDataSource = FeedRealmDataSource.shared,
        remoteDataSource: FeedRemoteDataSource = FeedRemoteDataSource.shared
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.userUUID = userUUID

        fetcher = Fetcher<[Feed], Error>(
            onRemoteCombine: { remoteDataSource.scrapFeedListPublisher(userUUID: userUUID)
                    .eraseToAnyPublisher() },
            onLocalCombine: { localDataSource.scrapFeedListPublisher() },
            onLocal: { localDataSource.cachedScrapFeedList() },
            onUpdateLocal: { localDataSource.updateScrapFeedListCache($0) },
            queue: RealmConfig.serialQueue
        )
    }

    private let reloadData = CurrentValueSubject<Void?, Never>(nil)
    private let hideIndicator = CurrentValueSubject<Void?, Never>(nil)
    private let showAlert = CurrentValueSubject<Error?, Never>(nil)

    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
        let viewWillDisappear: AnyPublisher<Void, Never>
        let viewDidRefresh: AnyPublisher<Void, Never>
        let pagination: AnyPublisher<Void, Never>
    }

    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let hideIndicator: AnyPublisher<Void, Never>
        let showAlert: AnyPublisher<Error, Never>
    }

    func transform(input: Input) -> Output {
        input.viewWillDisappear
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.temporaryCancelBag = Set<AnyCancellable>()
            }
            .store(in: &cancelBag)

        input.viewWillAppear
            .merge(with: input.viewDidRefresh)
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.fetcher.fetch { status, data in
                    self.scrapFeedData = data

                    switch status {
                    case .loading:
                        self.reloadData.send(Void())
                    case .success:
                        self.hideIndicator.send(Void())
                        self.reloadData.send(Void())
                    case .failure(let error):
                        self.hideIndicator.send(Void())
                        self.showAlert.send(error)
                    }
                }
                .store(in: &self.temporaryCancelBag)
            }
            .store(in: &cancelBag)

        return Output(
            reloadData: reloadData.unwrap().eraseToAnyPublisher(),
            hideIndicator: hideIndicator.unwrap().eraseToAnyPublisher(),
            showAlert: showAlert.unwrap().eraseToAnyPublisher()
        )
    }

    func dequeueCellViewModel(at index: Int) -> ScrapViewModel {
        let scrapViewModel = ScrapViewModel(
            feedUUID: scrapFeedData[index].feedUUID,
            feedLocalDataSource: FeedRealmDataSource.shared,
            feedRemoteDataSource: FeedRemoteDataSource.shared
        )
        return scrapViewModel
    }
}
