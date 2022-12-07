//
//  Coordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var cancelBag: Set<AnyCancellable> { get set }

    init(navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
    }

    func remove(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== childCoordinator })
    }
}

protocol NormalCoordinator: Coordinator {
    func start()
}

protocol TabBarChildCoordinator: Coordinator {
    func start(viewController: UIViewController)
}
