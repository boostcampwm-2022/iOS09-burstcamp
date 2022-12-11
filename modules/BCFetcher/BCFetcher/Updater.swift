//
//  Updater.swift
//  BCFetcher
//
//  Created by SEUNGMIN OH on 2022/12/12.
//

import Combine
import Foundation

public final class Updater<Data, Failure>
where Data: Equatable, Failure: Error {
    
    // Remote
    public var onRemoteCombine: ((Data) -> AnyPublisher<Void, Failure>)
    
    // Local
    public var onLocalCombine: (() -> AnyPublisher<Data, Failure>)
    public var onLocal: (() -> Data)
    public var onUpdateLocal: (() -> Void)
    
    public init(
        onRemoteCombine: @escaping (Data) -> AnyPublisher<Void, Failure>,
        onLocalCombine:@autoclosure @escaping () -> AnyPublisher<Data, Failure>,
        onLocal: @autoclosure @escaping () -> Data,
        onUpdateLocal: @autoclosure @escaping () -> Void
    ) {
        self.onRemoteCombine = onRemoteCombine
        self.onLocalCombine = onLocalCombine
        self.onLocal = onLocal
        self.onUpdateLocal = onUpdateLocal
    }

    private var updateDidTrigger = PassthroughSubject<Void, Never>()

    public func update() {
        updateDidTrigger.send(Void())
    }

    public func configure(
        _ onNext: @escaping (_ status: Status<Failure>, _ data: Data) -> Void
    ) -> Set<AnyCancellable> {
        var cancelBag = Set<AnyCancellable>()
        
        onNext(.success, onLocal())
        
        updateDidTrigger.sink { _ in
            onNext(.loading, self.onLocal())
            // local storage에 있는 데이터를 기반으로 업데이트를 진행한다.
            self.onRemoteCombine(self.onLocal())
                .sink(receiveCompletion: { response in
                    if case let .failure(error) = response {
                        onNext(.failure(error), self.onLocal())
                    }
                }, receiveValue: { _ in
                    self.onUpdateLocal()

                    self.onLocalCombine()
                        .sink { response in
                            if case let .failure(error) = response {
                                onNext(.failure(error), self.onLocal())
                            }
                        } receiveValue: { data in
                            onNext(.success, data)
                        }
                        .store(in: &cancelBag)
                })
                .store(in: &cancelBag)
        }
        .store(in: &cancelBag)

        return cancelBag
    }
}
