//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

protocol AuthCoordinatorProtocol: CoordinatorPublisher {
    func moveToTabBarFlow()
    // TODO: 할 일
    // to Github WebView
    // to 회원가입 - 도메인 선택
    // to 회원가입 - 캠퍼ID 선택
    // to 회원가입 - 블로그 선택
    // to 홈 화면
}

final class AuthCoordinator: AuthCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    var disposableBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginViewController = LoginViewController()
        loginViewController
            .coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToAuthFlow:
                    return
                case .moveToTabBarFlow:
                    self.coordinatorPublisher.send(.moveToTabBarFlow)
                }
            }
            .store(in: &disposableBag)
        navigationController.viewControllers = [loginViewController]
    }

    func moveToTabBarFlow() {
        coordinatorPublisher.send(.moveToTabBarFlow)
        finish()
    }
}
