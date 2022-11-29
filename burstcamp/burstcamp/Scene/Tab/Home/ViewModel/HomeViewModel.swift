//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import Foundation

final class HomeViewModel {

    let homeFireStore = HomeFireStore()
    var normalFeedData: [Feed] = []
    var cancelBag = Set<AnyCancellable>()
    
    struct Input {
        let viewDidAppear: AnyPublisher<Void, Never>
        let viewRefresh: AnyPublisher<Void, Never>
    }

    enum FetchResult {
        case fetchFail(error: Error)
        case fetchSuccess
    }

    struct Output {
        var fetchResult = PassthroughSubject<FetchResult, Never>()
    }

    func transform(input: Input, cancelBag: inout Set<AnyCancellable>) -> Output {
        let output = Output()

        input.viewDidAppear
            .sink { _ in
                self.fetchNormalFeed()
                output.fetchResult.send(.fetchSuccess)
            }
            .store(in: &cancelBag)

        input.viewRefresh
            .sink { _ in
                self.fetchNormalFeed()
                output.fetchResult.send(.fetchSuccess)
            }
            .store(in: &cancelBag)

        return output
    }

    init() {
        fetchNormalFeed()
        fetchNormalFeed()
    }

    private func fetchNormalFeed() {
        homeFireStore.fetchFeed()
    }
}
