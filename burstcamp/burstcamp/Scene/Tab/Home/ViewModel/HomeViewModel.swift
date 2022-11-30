//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

final class HomeViewModel {

    let homeFireStore: HomeFireStore
    var normalFeedData: [Feed] = []
    var cancelBag = Set<AnyCancellable>()

    init(homeFireStore: HomeFireStore) {
        self.homeFireStore = homeFireStore
    }

    struct Input {
        let viewRefresh: AnyPublisher<Bool, Never>
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

        input.viewRefresh
            .sink { [weak self] _ in
                self?.fetchFeed(output: output)
            }
            .store(in: &cancelBag)

        return output
    }

    func fetchFeed(output: Output) {
        self.homeFireStore.fetchFeed()
            .sink { completion in
                switch completion {
                case .finished:
                    output.fetchResult.send(.fetchSuccess)
                case .failure(let error):
                    output.fetchResult.send(.fetchFail(error: error))
                }
            } receiveValue: { [weak self] feeds in
                self?.normalFeedData = feeds
            }
            .store(in: &cancelBag)
    }
}
