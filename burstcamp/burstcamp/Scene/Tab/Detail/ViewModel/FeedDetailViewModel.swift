//
//  FeedDetailViewModel.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import Combine
import Foundation

final class FeedDetailViewModel {

    private let firestoreFeedService: FirestoreFeedService

    private let feed = CurrentValueSubject<Feed?, Never>(nil)
    private let dbUpdateResult = PassthroughSubject<Bool, Never>()
    private var cancelBag = Set<AnyCancellable>()

    init(firestoreFeedService: FirestoreFeedService) {
        self.firestoreFeedService = firestoreFeedService
    }

    convenience init(feed: Feed) {
        let firestoreFeedService = DefaultFirestoreFeedService()
        self.init(firestoreFeedService: firestoreFeedService)
        self.feed.send(feed)
    }

    convenience init(feedUUID: String) {
        let firestoreFeedService = DefaultFirestoreFeedService()
        self.init(firestoreFeedService: firestoreFeedService)
        self.fetchFeed(feedUUID: feedUUID)
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
        let feedDidUpdate = feed
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let openBlog = input.blogButtonDidTap
            .compactMap { self.feed.value?.url }
            .compactMap { URL(string: $0) }
            .eraseToAnyPublisher()

        let openActivityView = input.shareButtonDidTap
            .compactMap { self.feed.value?.url }
            .eraseToAnyPublisher()

        let sharedDBUpdateResult = dbUpdateResult
            .map { _ in Void() }
            .share()

        return Output(
            feedDidUpdate: feedDidUpdate,
            openBlog: openBlog,
            openActivityView: openActivityView
        )
    }

    private func fetchFeed(feedUUID: String) {
        Task { [weak self] in
            do {
                guard let feedDTODictionary = try await self?.firestoreFeedService.fetchFeedDTO(
                    feedUUID: feedUUID
                ) else {
                    throw ConvertError.dictionaryUnwrappingError
                }
                let feedDTO = FeedDTO(data: feedDTODictionary)

                guard let feedWriterDictionary = try await self?.firestoreFeedService.fetchUser(
                    userUUID: feedDTO.writerUUID
                ) else {
                    throw ConvertError.dictionaryUnwrappingError
                }
                let feedWriter = FeedWriter(data: feedWriterDictionary)

                let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                self?.feed.send(feed)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
