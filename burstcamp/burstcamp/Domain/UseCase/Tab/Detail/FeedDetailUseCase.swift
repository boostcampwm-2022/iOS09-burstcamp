//
//  FeedDetailUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol FeedDetailUseCase {
    func fetchFeed(by feedUUID: String) async throws -> Feed

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed

    func blockFeed(_ feed: Feed) async throws
    func reportFeed(_ feed: Feed) async throws
}
