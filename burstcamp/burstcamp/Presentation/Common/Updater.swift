//
//  Updater.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Combine
import Foundation

final class Updater<Data, Failure>
where Data: Equatable, Failure: Error {
//    
//    // Remote
//    public var onUpdateRemoteCombine: ((Data) -> AnyPublisher<Data, Failure>)
//    
//    // Local
//    public var onLocalCombine: (() -> AnyPublisher<Data, Failure>)
//    public var onLocal: (() -> Data)
//    public var onUpdateLocal: ((Data) -> Void)
//
//    private let queue: DispatchQueue
//    
//    public init(
//        onUpdateRemoteCombine: @escaping (Data) -> AnyPublisher<Data, Failure>,
//        onLocalCombine: @escaping () -> AnyPublisher<Data, Failure>,
//        debug: Bool = false,
//        queue: DispatchQueue
//    ) {
//        if debug {
//            self.onUpdateRemoteCombine = {
//                print("onUpdateRemoteCombine")
//                return onUpdateRemoteCombine($0)
//            }
//            self.onLocalCombine = {
//                print("onLocalCombine")
//                return onLocalCombine()
//            }
//        } else {
//            self.onUpdateRemoteCombine = onUpdateRemoteCombine
//            self.onLocalCombine = onLocalCombine
//        }
//        self.queue = queue
//    }
//
//    private let updateDidTrigger = PassthroughSubject<Void, Never>()
//
//    /// Updater의 라이프사이클을 따라감
//    private var innerCancelBag = Set<AnyCancellable>()
//
//    private var outerCancelBag = Set<AnyCancellable>()
//
//    public func update() {
//        // 이전의 Local 구독을 초기화
//        outerCancelBag = Set<AnyCancellable>()
//        updateDidTrigger.send(Void())
//    }
//
//    public func cancelConnection() {
//        outerCancelBag = Set<AnyCancellable>()
//    }
//
//    public func configure(
//        _ onNext: @escaping (_ status: Status<Failure>, _ data: Data) -> Void
//    ) {
//        
//        updateDidTrigger
//            .receive(on: queue)
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//
//                // local storage에 있는 데이터를 기반으로 업데이트를 진행한다.
//                self.onUpdateRemoteCombine(self.onLocal())
//                    .receive(on: self.queue) // 특정한 Queue에서 동작한다.
//                    .prefix(1) // Remote에서 한 번 받아온 뒤 구독을 종료한다.
//                    .sink(receiveCompletion: { response in
//                        if case let .failure(error) = response {
//                            onNext(.failure(error), self.onLocal())
//                        }
//                    }, receiveValue: { updatedFeed in
//
//                        self.onLocalCombine()
//                            .sink { response in
//                                if case let .failure(error) = response {
//                                    onNext(.failure(error), self.onLocal())
//                                }
//                            } receiveValue: { data in
//                                onNext(.success, data)
//                            }
//                            .store(in: &self.outerCancelBag)
//                    })
//                    .store(in: &self.innerCancelBag)
//            }
//            .store(in: &innerCancelBag)
//    }
}
