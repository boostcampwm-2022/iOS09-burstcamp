//
//  FeedRepositoryError.swift
//  burstcamp
//
//  Created by youtak on 2023/01/31.
//

import Foundation

enum FeedRepositoryError: Error {
    case fetchRecentHomeFeedList
    case fetchMoreNormalFeed
    case fetchRecentScrapFeed
    case fetchMoreScrapFeed
}
