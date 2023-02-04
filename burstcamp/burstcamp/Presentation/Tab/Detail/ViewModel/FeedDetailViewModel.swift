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
        handleDeepLinkFeed(feedUUID: feedUUID)
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
        let scrapButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let feedDidUpdate: AnyPublisher<Feed?, Never>
        let openBlog: AnyPublisher<URL, Never>
        let openActivityView: AnyPublisher<String, Never>
        let scrapUpdate: AnyPublisher<Feed?, Error>
    }

    func transform(input: Input) -> Output {

        let scrapUpdate = input.scrapButtonDidTap
            .asyncMap { [weak self] _ in
                try await self?.scrapFeed()
            }
            .eraseToAnyPublisher()

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
            feedDidUpdate: feedPublisher.eraseToAnyPublisher(),
            openBlog: openBlog,
            openActivityView: openActivityView,
            scrapUpdate: scrapUpdate
        )
    }

    func getFeed() -> Feed? {
        return feedPublisher.value
    }

    private func scrapFeed() async throws -> Feed {
        guard let feed = getFeed() else {
            throw FeedDetailViewModelError.feedIsNil
        }

        let userUUID = UserManager.shared.user.userUUID
        let updatedFeed = try await feedDetailUseCase.scrapFeed(feed, userUUID: userUUID)
        feedPublisher.value = updatedFeed
        return updatedFeed
    }

    private func handleDeepLinkFeed(feedUUID: String) {
    }
}
