//
//  AnyCancellable + store.swift
//  BCFetcher
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import Foundation
import Combine

public extension Set where Element == AnyCancellable {
    func store(in set: inout Self) {
        self.forEach { cancellable in
            cancellable.store(in: &set)
        }
    }
}
