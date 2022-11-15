//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func toGithubWebView()
}

final class AuthoCoordinator: AuthCoordinatorProtocol {

    var childCoordinator: [Coordinator] = []
    var navigationCotroller: UINavigationController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app

    init(_ navigationController: UINavigationController) {
        self.navigationCotroller = navigationController
    }

    func start() {
    }

    func toGithubWebView() {
    }
}
