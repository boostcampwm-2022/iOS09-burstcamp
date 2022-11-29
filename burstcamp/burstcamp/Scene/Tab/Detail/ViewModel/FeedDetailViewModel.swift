//
//  FeedDetailViewModel.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import Combine
import Foundation

import FirebaseFirestore

final class FeedDetailViewModel {
    private let feed: Feed

    init(feed: Feed) {
        self.feed = feed
    }
    
    struct Input {
        let blogButtonDidTap: AnyPublisher<Void, Never>
        let scrapButtonDidTap: AnyPublisher<Void, Never>
        let shareButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let openBlog: AnyPublisher<URL?, Never>
        let scrapButtonToggle: AnyPublisher<Void, Never>
        let openActivityView: AnyPublisher<String, Never>
    }

    func transform(input: Input) -> Output {
        let openBlog = input.blogButtonDidTap
            .map { URL(string: self.feed.url) }
            .eraseToAnyPublisher()

        let openActivityView = input.shareButtonDidTap
            .map { self.feed.url }
            .eraseToAnyPublisher()

        return Output(
            openBlog: openBlog,
            scrapButtonToggle: input.scrapButtonDidTap,
            openActivityView: openActivityView
        )
    }
}
