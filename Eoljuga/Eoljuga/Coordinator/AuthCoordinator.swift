//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func toGithubWebView() // github WebView
    // to 회원가입 - 도메인 선택
    // to 회원가입 - 캠퍼ID 선택
    // to 회원가입 - 블로그 선택
    // to 홈 화면
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
        let loginViewController = LoginViewController()
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func toGithubWebView() {
    }
}
