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
    func moveToDomainScreen()
    func moveToIDScreen()
    func moveToBlogScreen()
    func moveToGithubLogIn()
}

final class AuthCoordinator: AuthCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorPublisher = PassthroughSubject<AppCoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func displayIndicator() {
        guard let logInViewController = navigationController.viewControllers.first(
            where: { $0 is LogInViewController }) as? LogInViewController
        else {
            return
        }
        logInViewController.displayIndicator()
    }

    func start() {
        let logInViewController = LogInViewController(viewModel: LogInViewModel())
        logInViewController.coordinatorPublisher
            .sink { coordinatorEvent in
                switch coordinatorEvent {
                case .moveToDomainScreen:
                    self.moveToDomainScreen()
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

    func moveToGithubLogIn() {
        let urlString = "https://github.com/login/oauth/authorize"

        guard var urlComponent = URLComponents(string: urlString),
              let clientID = LogInManager.shared.githubAPIKey?.clientID
        else {
            return
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "admin:org")
        ]

        guard let url = urlComponent.url else { return }
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }

    func moveToTabBarFlow() {
        coordinatorPublisher.send(.moveToTabBarFlow)
        finish()
    }

    func moveToDomainScreen() {
        let viewModel = SignUpDomainViewModel()
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
        let viewModel = SignUpCamperIDViewModel()
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
        let viewModel = SignUpBlogViewModel()
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
