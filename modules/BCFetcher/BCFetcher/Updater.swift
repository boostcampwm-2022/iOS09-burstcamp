//
//  Updater.swift
//  BCFetcher
//
//  Created by SEUNGMIN OH on 2022/12/12.
//

import Combine
import Foundation

/// Update를 담당합니다.
///
/// * Updater는 trigger가 발동될 때 마다, 지정된 작업을 진행합니다.
/// * trigger가 Updater 내부에 존재하기 때문에,
/// 모든 작업은 Updater가 존재하는 동안만 진행됩니다.
/// * trigger가 발동되지 않아도
public final class Updater<Data, Failure>
where Data: Equatable, Failure: Error {
    
    // Remote
    public var onUpdateRemoteCombine: ((Data) -> AnyPublisher<Data, Failure>)
    
    // Local
    public var onLocalCombine: (() -> AnyPublisher<Data, Failure>)
    public var onLocal: (() -> Data)
    public var onUpdateLocal: ((Data) -> Void)

    private let queue: DispatchQueue
    
    public init(
        onUpdateRemoteCombine: @escaping (Data) -> AnyPublisher<Data, Failure>,
        onLocalCombine: @escaping () -> AnyPublisher<Data, Failure>,
        onLocal: @escaping () -> Data,
        onUpdateLocal: @escaping (Data) -> Void,
        debug: Bool = false,
        queue: DispatchQueue
    ) {
        if debug {
            self.onUpdateRemoteCombine = {
                print("onUpdateRemoteCombine")
                return onUpdateRemoteCombine($0)
            }
            self.onLocalCombine = {
                print("onLocalCombine")
                return onLocalCombine()
            }
            self.onLocal = {
                print("onLocal")
                return onLocal()
            }
            self.onUpdateLocal = {
                print("onUpdateLocal")
                return onUpdateLocal($0)
            }
        } else {
            self.onUpdateRemoteCombine = onUpdateRemoteCombine
            self.onLocalCombine = onLocalCombine
            self.onLocal = onLocal
            self.onUpdateLocal = onUpdateLocal
        }
        self.queue = queue
    }

    private let updateDidTrigger = PassthroughSubject<Void, Never>()

    /// Updater의 라이프사이클을 따라감
    private var innerCancelBag = Set<AnyCancellable>()

    private var outerCancelBag = Set<AnyCancellable>()

    public func update() {
        // 이전의 Local 구독을 초기화
        outerCancelBag = Set<AnyCancellable>()
        updateDidTrigger.send(Void())
    }

    public func cancelConnection() {
        outerCancelBag = Set<AnyCancellable>()
    }

    public func configure(
        _ onNext: @escaping (_ status: Status<Failure>, _ data: Data) -> Void
    ) {
        onNext(.success, onLocal())
        
        updateDidTrigger
            .receive(on: queue)
            .sink { [weak self] _ in
                guard let self = self else { return }

                onNext(.loading, self.onLocal())

                // local storage에 있는 데이터를 기반으로 업데이트를 진행한다.
                self.onUpdateRemoteCombine(self.onLocal())
                    .receive(on: self.queue) // 특정한 Queue에서 동작한다.
                    .prefix(1) // Remote에서 한 번 받아온 뒤 구독을 종료한다.
                    .sink(receiveCompletion: { response in
                        if case let .failure(error) = response {
                            onNext(.failure(error), self.onLocal())
                        }
                    }, receiveValue: { updatedFeed in
                        self.onUpdateLocal(updatedFeed)

                        self.onLocalCombine()
                            .sink { response in
                                if case let .failure(error) = response {
                                    onNext(.failure(error), self.onLocal())
                                }
                            } receiveValue: { data in
                                onNext(.success, data)
                            }
                            .store(in: &self.outerCancelBag)
                    })
                    .store(in: &self.innerCancelBag)
            }
            .store(in: &innerCancelBag)
    }
}
