//
//  CoordinatorPublisher.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import Combine

protocol CoordinatorPublisher: Coordinator {
    var coordinatorPublisher: PassthroughSubject<CoordinatorEvent, Never> { get }
}
