//
//  Future+async.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Combine
import Foundation

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
