//
//  FeedDetailViewModel.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import Combine
import Foundation

final class FeedDetailViewModel {

    private let feedDetailUseCase: FeedDetailUseCase
    private let feed = CurrentValueSubject<Feed?, Never>(nil)
    private let feedLocalDataSource: FeedLocalDataSource
    private var cancelBag = Set<AnyCancellable>()

    init(feedDetailUseCase: FeedDetailUseCase) {
        self.feedDetailUseCase = feedDetailUseCase
        self.feedLocalDataSource = FeedRealmDataSource.shared
    }

    convenience init(feedDetailUseCase: FeedDetailUseCase, feed: Feed) {
        self.init(feedDetailUseCase: feedDetailUseCase)
        self.feed.send(feed)
    }

    /// DeepLink를 통해서 진입할 때 호출하는 initializer
    convenience init(feedDetailUseCase: FeedDetailUseCase, feedUUID: String) {
        self.init(feedDetailUseCase: feedDetailUseCase)
        // TODO: Cache에 데이터가 없을 수 있기 때문에 Remote에서 불러와야 한다.
        let feed = FeedRealmDataSource.shared.cachedNormalFeed(feedUUID: feedUUID)
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
