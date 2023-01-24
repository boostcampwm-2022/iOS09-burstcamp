//
//  DiffableFeed.swift
//  burstcamp
//
//  Created by youtak on 2023/01/24.
//

import Foundation

enum DiffableFeed: Hashable {
    case normal(Feed)
    case recommend(Feed)
}
