//
//  MyPageCoordinator.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import Combine
import UIKit

protocol MyPageCoordinatorProtocol: TabBarChildCoordinator {
    func moveToMyPageEditScreen(myPageViewController: MyPageViewController)
    func moveToOpenSourceScreen()
    func moveToAuthFlow()
    func moveMyPageEditScreenToBackScreen(
        myPageViewController: MyPageViewController,
        toastMessage: String
    )
}

final class MyPageCoordinator: MyPageCoordinatorProtocol, GithubLogInCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorPublisher = PassthroughSubject<TabBarCoordinatorEvent, Never>()
    var cancelBag = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private func prepareMyPageViewController(
        myPageViewController: MyPageViewController
    ) {
        myPageViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveToAuthFlow:
                    self?.moveToAuthFlow()
                case .moveToMyPageEditScreen:
                    self?.moveToMyPageEditScreen(
                        myPageViewController: myPageViewController
                    )
                case .moveToOpenSourceScreen:
                    self?.moveToOpenSourceScreen()
                case .moveToGithubLogIn:
                    self?.moveToGithubLogIn()
                default: break
                }
            }
            .store(in: &cancelBag)
    }

    private func prepareMyPageEditViewController(
        myPageViewController: MyPageViewController
    ) -> MyPageEditViewController {
        let viewModel = MyPageEditViewModel()
        let myPageEditViewController = MyPageEditViewController(viewModel: viewModel)

        myPageEditViewController.coordinatorPublisher
            .sink { [weak self] event in
                switch event {
                case .moveMyPageEditScreenToBackScreen(let toastMessage):
                    self?.moveMyPageEditScreenToBackScreen(
                        myPageViewController: myPageViewController,
                        toastMessage: toastMessage
                    )
                default: break
                }
            }
            .store(in: &cancelBag)

        return myPageEditViewController
    }
}

extension MyPageCoordinator {

    func start(viewController: UIViewController) {
        guard let myPageViewController = viewController as? MyPageViewController else {
            return
        }

        prepareMyPageViewController(myPageViewController: myPageViewController)
    }

    func moveToMyPageEditScreen(myPageViewController: MyPageViewController) {
        let myPageEditViewController = prepareMyPageEditViewController(
            myPageViewController: myPageViewController
        )
        navigationController.pushViewController(myPageEditViewController, animated: true)
    }

    func moveToOpenSourceScreen() {
        let openSourceLicenseViewController = OpenSourceLicenseViewController()
        navigationController.pushViewController(openSourceLicenseViewController, animated: true)
    }

    func moveToAuthFlow() {
        finish()
        coordinatorPublisher.send(.moveToAuthFlow)
    }

    func moveMyPageEditScreenToBackScreen(
        myPageViewController: MyPageViewController,
        toastMessage: String
    ) {
        navigationController.popViewController(animated: true)
        myPageViewController.toastMessagePublisher.send(toastMessage)
    }
}
