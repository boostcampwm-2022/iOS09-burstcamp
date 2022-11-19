//
//  FeedCellType.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import Foundation

enum FeedCellType: Int, CaseIterable {
    case recommend
    case normal

    var columnCount: Int {
        switch self {
        case .recommend: return 1
        case .normal: return 1
        }
    }
}
