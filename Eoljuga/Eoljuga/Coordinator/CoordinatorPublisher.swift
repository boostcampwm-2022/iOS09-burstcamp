//
//  CoordinatorPublisher.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import Combine

/// UIViewController에서 채택
/// Coordinator에게 이벤트를 쏴준다
protocol CoordinatorPublisher: AnyObject {
    var coordinatrPublisher: PassthroughSubject<CoordinatorEvent, Never> { get }
}
