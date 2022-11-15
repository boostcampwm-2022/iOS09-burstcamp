//
//  AppCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationCotroller: UINavigationController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app

    init(_ navigationController: UINavigationController) {
        self.navigationCotroller = navigationController
    }

    func start() {
    }
}
