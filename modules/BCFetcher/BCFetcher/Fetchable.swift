//
//  Fetchable.swift
//  BCFetcher
//
//  Created by SEUNGMIN OH on 2022/12/08.
//

import Combine
import Foundation

public protocol Fetchable {
    associatedtype Data
    associatedtype FetchingError: Error

    var queue: DispatchQueue { get }
    
    // Remote
    var onRemoteCombine: (() -> AnyPublisher<Data, FetchingError>) { get }
    
    // Local
    var onLocalCombine: (() -> AnyPublisher<Data, FetchingError>) { get }
    var onLocal: (() -> Data) { get }
    var onUpdateLocal: ((Data) -> Void) { get }
    
    init(
        onRemoteCombine: @escaping () -> AnyPublisher<Data, FetchingError>,
        onLocalCombine: @escaping () -> AnyPublisher<Data, FetchingError>,
        onLocal: @escaping () -> Data,
        onUpdateLocal: @escaping (Data) -> Void,
        queue: DispatchQueue
    )
    
    func fetch(_ onNext: @escaping (Status<FetchingError>, Data) -> Void) -> Set<AnyCancellable>
}
