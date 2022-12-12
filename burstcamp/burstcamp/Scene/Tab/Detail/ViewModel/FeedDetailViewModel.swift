//
//  FeedDetailViewModel.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import Combine
import Foundation

final class FeedDetailViewModel {

    private let feed = CurrentValueSubject<Feed?, Never>(nil)
    private let feedLocalDataSource: FeedLocalDataSource
    private var cancelBag = Set<AnyCancellable>()

    init(feedLocalDataSource: FeedLocalDataSource = FeedLocalDataSource.shared) {
        self.feedLocalDataSource = feedLocalDataSource
    }

    convenience init(feed: Feed) {
        self.init()
        self.feed.send(feed)
    }

    convenience init(feedUUID: String) {
        self.init()
        let feed = FeedLocalDataSource.shared.cachedNormalFeed(feedUUID: feedUUID)
        self.feed.send(feed)
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed, Never>
        let openBlog: AnyPublisher<URL, Never>
        let openActivityView: AnyPublisher<String, Never>
    }

    func transform(input: Input) -> Output {
        let openBlog = input.blogButtonDidTap
            .compactMap { self.feed.value?.url }
            .compactMap { URL(string: $0) }
            .eraseToAnyPublisher()

        let openActivityView = input.shareButtonDidTap
            .compactMap { self.feed.value?.url }
            .eraseToAnyPublisher()

        return Output(
            feedDidUpdate: feed.unwrap().eraseToAnyPublisher(),
            openBlog: openBlog,
            openActivityView: openActivityView
        )
    }
}
