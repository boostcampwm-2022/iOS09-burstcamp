//
//  FeedCellType.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import Foundation

/// Home에서 CellType을 분류할 때 사용되는 `enum`
enum FeedCellType: Int, CaseIterable {
    case recommend
    case normal
}

extension FeedCellType {
    init?(index: Int) {
        self.init(rawValue: index)
    }

    var columnCount: Int {
        switch self {
        case .recommend: return 1
        case .normal: return 1
        }
    }

    var index: Int {
        return self.rawValue
    }

    var collectionPath: String {
        switch self {
        case .recommend: return FirestoreCollection.recommendFeed.path
        case .normal: return FirestoreCollection.normalFeed.path
        }
    }

    static var count: Int {
        return Self.allCases.count
    }
}
