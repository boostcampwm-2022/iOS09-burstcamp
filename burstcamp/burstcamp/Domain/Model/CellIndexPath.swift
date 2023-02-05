//
//  CellIndexPath.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/23.
//

import Foundation

struct CellIndexPath: Equatable {
    let indexPath: (Int, Int)

    static func == (lhs: CellIndexPath, rhs: CellIndexPath) -> Bool {
        return lhs.indexPath.0 == rhs.indexPath.0 &&
        lhs.indexPath.1 == rhs.indexPath.1
    }
}
