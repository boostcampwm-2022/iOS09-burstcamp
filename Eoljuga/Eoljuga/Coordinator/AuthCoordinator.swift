//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

enum AuthCoordinatorEvent {
    case moveToIDScreen
    case moveToBlogScreen
}

protocol AuthCoordinatorProtocol: CoordinatorPublisher {
    func moveToTabBarFlow()
    func moveToDomainScreen()
    func moveToIDScreen(viewModel: SignUpViewModel)
    func moveToBlogScreen(viewModel: SignUpViewModel)
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

    func moveToDomainScreen() {
        let sighUpDomainViewController = SignUpDomainViewController(viewModel: SignUpViewModel())
        sighUpDomainViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                if coordinatorEvent == .moveToIDScreen {
                    self.moveToIDScreen(viewModel: viewModel)
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(sighUpDomainViewController, animated: true)
    }

    func moveToIDScreen(viewModel: SignUpViewModel) {
        let signUpCamperIDViewController = SignUpCamperIDViewController(viewModel: viewModel)
        signUpCamperIDViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                if coordinatorEvent == .moveToBlogScreen {
                    self.moveToBlogScreen(viewModel: viewModel)
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(signUpCamperIDViewController, animated: false)
    }

    func moveToBlogScreen(viewModel: SignUpViewModel) {
        let signUpBlogViewController = SignUpBlogViewController(viewModel: viewModel)
        signUpBlogViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                if coordinatorEvent == .moveToTabBarFlow {
                    self.coordinatorPublisher.send(.moveToTabBarFlow)
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(signUpBlogViewController, animated: false)
    }
}
