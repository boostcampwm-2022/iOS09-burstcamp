//
//  FeedDetailUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol FeedDetailUseCase {
    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed
}
