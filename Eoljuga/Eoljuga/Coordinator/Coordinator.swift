//
//  Coordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

enum CoordinatorType {
    case app
    case auth
    case tab
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var type: CoordinatorType { get }

    init(_ navigationController: UINavigationController)

    func start()
}

extension Coordinator {
    func finish() {
        childCoordinator.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
