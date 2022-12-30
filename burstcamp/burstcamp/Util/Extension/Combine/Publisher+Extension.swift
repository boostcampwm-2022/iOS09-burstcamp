//
//  Publisher+Extension.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import Combine

extension Publisher {
    func mapToVoid() -> Publishers.Map<Self, Void> {
        return self.map { _ in Void() }
    }

    func unwrap<Result>() -> Publishers.CompactMap<Self, Result>
    where Output == Result? {
        return self.compactMap { $0 }
    }
}

extension Publisher where Self.Failure == Never {

    /// publisher에서 방출된 각 element를 object의 property에 할당한다.
    ///
    /// `assign(to:)`와는 다르게, object를 weak capture한다.
    /// - Note: [Does 'assign(to:)' produce memory leaks?](https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546/9) 참고
    ///

    func weakAssign<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        on object: Root
    ) -> AnyCancellable
    where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}
