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

    init() {
        fetchNormalFeed()
        bind()
        fetchNormalFeed()
    }

    private func fetchNormalFeed() {
        homeFireStore.fetchFeed()
    }

    private func bind() {
        homeFireStore.feedPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("데이터")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { feeds in
                self.normalFeedData = feeds
                print(self.normalFeedData)
            }
            .store(in: &cancelBag)
    }
}
