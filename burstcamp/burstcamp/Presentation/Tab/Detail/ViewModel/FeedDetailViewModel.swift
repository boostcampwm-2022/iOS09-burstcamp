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
    private let feedPublisher = CurrentValueSubject<Feed?, Never>(nil)
    private let scrapPublisher = CurrentValueSubject<Feed?, Never>(nil)
    private var cancelBag = Set<AnyCancellable>()

    init(feedDetailUseCase: FeedDetailUseCase) {
        self.feedDetailUseCase = feedDetailUseCase
    }

    convenience init(feedDetailUseCase: FeedDetailUseCase, feed: Feed) {
        self.init(feedDetailUseCase: feedDetailUseCase)
        self.feedPublisher.send(feed)
    }

    /// DeepLink를 통해서 진입할 때 호출하는 initializer
    convenience init(feedDetailUseCase: FeedDetailUseCase, feedUUID: String) {
        self.init(feedDetailUseCase: feedDetailUseCase)
        // TODO: Cache에 데이터가 없을 수 있기 때문에 Remote에서 불러와야 한다.
        let feed = FeedRealmDataSource.shared.cachedNormalFeed(feedUUID: feedUUID)
        self.feedPublisher.send(feed)
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
        let scrapButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed, Never>
        let openBlog: AnyPublisher<URL, Never>
        let openActivityView: AnyPublisher<String, Never>
        let scrapUpdate: AnyPublisher<Feed, Never>
    }

    func transform(input: Input) -> Output {
        input.scrapButtonDidTap
            .sink { [weak self] _ in
                self?.scrapPublisher.send(nil)
            }
            .store(in: &cancelBag)

        let openBlog = input.blogButtonDidTap
            .compactMap { [weak self] in
                self?.feedPublisher.value?.url
            }
            .compactMap { URL(string: $0) }
            .eraseToAnyPublisher()

        let openActivityView = input.shareButtonDidTap
            .compactMap { [weak self] in
                self?.feedPublisher.value?.url
            }
            .eraseToAnyPublisher()

        return Output(
            feedDidUpdate: feedPublisher.unwrap().eraseToAnyPublisher(),
            openBlog: openBlog,
            openActivityView: openActivityView,
            scrapUpdate: scrapPublisher.unwrap().eraseToAnyPublisher()
        )
    }

    func getFeed() -> Feed? {
        return feedPublisher.value
    }
}
