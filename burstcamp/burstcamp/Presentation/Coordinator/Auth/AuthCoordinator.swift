//
//  AuthCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import SafariServices
import UIKit

protocol AuthCoordinatorProtocol: NormalCoordinator {
    func moveToTabBarFlow()
    func moveToDomainScreen(userNickname: String)
    func moveToIDScreen()
    func moveToBlogScreen()
}

final class AuthCoordinator: AuthCoordinatorProtocol, GithubLogInCoordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorPublisher = PassthroughSubject<AppCoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()
    var dependencyFactory: DependencyFactoryProtocol

    init(navigationController: UINavigationController, dependencyFactory: DependencyFactoryProtocol) {
        self.navigationController = navigationController
        self.dependencyFactory = dependencyFactory
    }

    func start() {
        let loginViewModel = dependencyFactory.createLoginViewModel()
        let logInViewController = LogInViewController(viewModel: loginViewModel)
        logInViewController.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToDomainScreen(let userNickname):
                    self.moveToDomainScreen(userNickname: userNickname)
                case .moveToTabBarScreen:
                    self.moveToTabBarFlow()
                case .moveToGithubLogIn:
                    self.moveToGithubLogIn()
                case .moveToIDScreen, .moveToBlogScreen, .showAlert(_):
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

    func moveToDomainScreen(userNickname: String) {
        let viewModel = dependencyFactory.createSignUpDomainViewModel(userNickname: userNickname)
        let sighUpDomainViewController = SignUpDomainViewController(viewModel: viewModel)
        sighUpDomainViewController.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToIDScreen:
                    self.moveToIDScreen()
                default:
                    return
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(sighUpDomainViewController, animated: true)
    }

    func moveToIDScreen() {
        let viewModel = dependencyFactory.createSignUpCamperIDViewModel()
        let signUpCamperIDViewController = SignUpCamperIDViewController(viewModel: viewModel)
        signUpCamperIDViewController.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToBlogScreen:
                    self.moveToBlogScreen()
                default:
                    return
                }
            }
            .store(in: &cancelBag)
        navigationController.pushViewController(signUpCamperIDViewController, animated: false)
    }

    func moveToBlogScreen() {
        let viewModel = dependencyFactory.createSignUpBlogViewModel()
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
