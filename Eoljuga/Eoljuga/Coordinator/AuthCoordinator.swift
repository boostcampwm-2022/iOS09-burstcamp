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

final class AuthCoordinator: AuthCoordinatorProtocol {

    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .auth

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
    }

    func toGithubWebView() {
    }
}
