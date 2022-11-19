//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

enum AuthCoordinatorEvent {
    case moveToDomainFlow
    case moveToIDFlow
    case moveToBlogFlow
}

protocol AuthCoordinatorProtocol: CoordinatorPublisher {
    func moveToTabBarFlow()
    func moveToDomainFlow()
    func moveToIDFlow(viewModel: SignUpViewModel)
    func moveToBlogFlow(viewModel: SignUpViewModel)
    // to 홈 화면
}

final class AuthCoordinator: AuthCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let logInViewController = LogInViewController(viewModel: LogInViewModel())
        navigationController.viewControllers = [logInViewController]
    }

    func moveToTabBarFlow() {
        coordinatorPublisher.send(.moveToTabBarFlow)
        finish()
    }

    func moveToDomainFlow() {
        let domainViewController = DomainViewController(viewModel: SignUpViewModel())
        domainViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                if coordinatorEvent == .moveToIDFlow {
                    self.moveToIDFlow(viewModel: viewModel)
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(domainViewController, animated: true)
    }

    func moveToIDFlow(viewModel: SignUpViewModel) {
        let camperIDViewController = CamperIDViewController(viewModel: viewModel)
        camperIDViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                if coordinatorEvent == .moveToBlogFlow {
                    self.moveToBlogFlow(viewModel: viewModel)
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(camperIDViewController, animated: false)
    }

    func moveToBlogFlow(viewModel: SignUpViewModel) {
    }
}
