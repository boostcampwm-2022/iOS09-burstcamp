//
//  Sequence+Async.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import Foundation

extension Sequence {
    func asyncMap<T> (
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
