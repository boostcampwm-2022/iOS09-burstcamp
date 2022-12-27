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
        onLocalCombine: @escaping () -> AnyPublisher<Data, Failure>,
        onLocal: @escaping () -> Data,
        onUpdateLocal: @escaping () -> Void
    ) {
        self.onRemoteCombine = onRemoteCombine
        self.onLocalCombine = onLocalCombine
        self.onLocal = onLocal
        self.onUpdateLocal = onUpdateLocal
    }

    private let updateDidTrigger = PassthroughSubject<Void, Never>()

    private var cancelBag = Set<AnyCancellable>()

    public func update() {
        // 이전의 구독을 초기화
        cancelBag = Set<AnyCancellable>()
        updateDidTrigger.send(Void())
    }

    public func configure(
        _ onNext: @escaping (_ status: Status<Failure>, _ data: Data) -> Void
    ) -> Set<AnyCancellable> {

        onNext(.success, onLocal())
        
        updateDidTrigger
            .sink { [weak self] _ in
            guard let self = self else { return }

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
                        .store(in: &self.cancelBag)
                })
                .store(in: &self.cancelBag)
        }
        .store(in: &cancelBag)

        return cancelBag
    }
}
