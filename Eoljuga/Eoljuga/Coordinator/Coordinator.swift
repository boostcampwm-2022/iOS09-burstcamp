//
//  Coordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

enum CoordinatorEvent {
    case moveToAuthFlow
    case moveToTabBarFlow
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var coordinatorPublisher: PassthroughSubject<CoordinatorEvent, Never> { get }
    var disposableBag: Set<AnyCancellable> { get }

    init(navigationController: UINavigationController)

    func start()
}

extension Coordinator {
    func finish(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
}
