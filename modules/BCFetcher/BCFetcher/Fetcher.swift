//
//  Fetcher.swift
//  BCFetcher
//
//  Created by SEUNGMIN OH on 2022/12/08.
//

import Combine
import Foundation

public final class Fetcher<Data, FetchingError>: Fetchable
where Data: Equatable, FetchingError: Error {
    
    // Remote
    public var onRemoteCombine: (() -> AnyPublisher<Data, FetchingError>)
    
    // Local
    public var onLocalCombine: (() -> AnyPublisher<Data, FetchingError>)
    public var onLocal: (() -> Data)
    public var onUpdateLocal: ((Data) -> Void)
    
    public init(
        onRemoteCombine: @autoclosure @escaping () -> AnyPublisher<Data, FetchingError>,
        onLocalCombine:@autoclosure @escaping () -> AnyPublisher<Data, FetchingError>,
        onLocal: @autoclosure @escaping () -> Data,
        onUpdateLocal: @escaping (Data) -> Void
    ) {
        self.onRemoteCombine = onRemoteCombine
        self.onLocalCombine = onLocalCombine
        self.onLocal = onLocal
        self.onUpdateLocal = onUpdateLocal
    }
    
    public func fetch(
        _ onNext: @escaping (_ status: Status<FetchingError>, _ data: Data) -> Void
    ) -> Set<AnyCancellable> {
        var cancelBag = Set<AnyCancellable>()
        
        // 저장된 데이터를 보여주며, loading을 시작
        onNext(.loading, onLocal())
        
        onRemoteCombine()
            .sink(receiveCompletion: { response in
                if case let .failure(error) = response {
                    // 저장한 데이터를 보여주며, error 발생을 알림
                    onNext(.failure(error), self.onLocal())
                }
            },receiveValue: { data in
//                if data == self.onLocal() {
//                    // 이미 있는 데이터
//                    onNext(.alreadyLatest, data)
//                    return
//                } else {
                    // local storage를 업데이트
                    self.onUpdateLocal(data)
//                }
                
                // local storage를 구독하면서, 데이터를 중계(relay)한다.
                self.onLocalCombine()
                    .sink(
                        receiveCompletion: { response in
                            if case let .failure(error) = response {
                                // 저장한 데이터를 보여주며, error 발생을 알림
                                onNext(.failure(error), self.onLocal())
                            }
                        },
                        receiveValue: { data in
                            onNext(.success, data)
                        }
                    )
                    .store(in: &cancelBag)
            })
            .store(in: &cancelBag)
        
        return cancelBag
    }
}
