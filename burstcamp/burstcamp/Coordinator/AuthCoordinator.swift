//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func moveToTabBarFlow()
    func moveToDomainScreen(userUUID: String, nickname: String)
    func moveToIDScreen(viewModel: SignUpViewModel)
    func moveToBlogScreen(viewModel: SignUpViewModel)
    // to 홈 화면
}

final class AuthCoordinator: AuthCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorPublisher = PassthroughSubject<AppCoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let logInViewController = LogInViewController(viewModel: LogInViewModel())
        logInViewController.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToDomainScreen(let userUUID, let nickname):
                    self.moveToDomainScreen(userUUID: userUUID, nickname: nickname)
                case .moveToTabBarScreen:
                    self.moveToTabBarFlow()
                case .moveToIDScreen, .moveToBlogScreen, .notCamper:
                    return
                }
            }
            .store(in: &cancelBag)
        navigationController.viewControllers = [logInViewController]
    }

    func moveToTabBarFlow() {
        coordinatorPublisher.send(.moveToTabBarFlow)
        finish()
    }

    func moveToDomainScreen(userUUID: String, nickname: String) {
        let sighUpDomainViewController = SignUpDomainViewController(
            viewModel: SignUpViewModel(userUUID: userUUID, nickname: nickname)
        )
        sighUpDomainViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                switch coordinatorEvent {
                case .moveToIDScreen:
                    self.moveToIDScreen(viewModel: viewModel)
                default:
                    return
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(sighUpDomainViewController, animated: true)
    }

    func moveToIDScreen(viewModel: SignUpViewModel) {
        let signUpCamperIDViewController = SignUpCamperIDViewController(viewModel: viewModel)
        signUpCamperIDViewController.coordinatorPublisher
            .sink { coordinatorEvent, viewModel in
                switch coordinatorEvent {
                case .moveToBlogScreen:
                    self.moveToBlogScreen(viewModel: viewModel)
                default:
                    return
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(signUpCamperIDViewController, animated: false)
    }

    func moveToBlogScreen(viewModel: SignUpViewModel) {
        let signUpBlogViewController = SignUpBlogViewController(viewModel: viewModel)
        signUpBlogViewController.coordinatorPublisher
            .sink { coordinatorEvent in
                if coordinatorEvent == .moveToTabBarFlow {
                    self.coordinatorPublisher.send(.moveToTabBarFlow)
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(signUpBlogViewController, animated: false)
    }
}
