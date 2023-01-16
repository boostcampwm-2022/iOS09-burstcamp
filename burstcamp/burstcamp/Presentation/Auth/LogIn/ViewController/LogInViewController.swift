//
//  LoginViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import SafariServices
import UIKit

import SnapKit
import Then

final class LogInViewController: UIViewController {

    private var logInView: LogInView {
        guard let view = view as? LogInView else { return LogInView() }
        return view
    }

    var coordinatorPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()
    private var cancelBag = Set<AnyCancellable>()

    private let viewModel: LogInViewModel

    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = LogInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func displayIndicator() {
        logInView.activityIndicator.startAnimating()
        logInView.loadingLabel.isHidden = false
        logInView.camperAuthButton.isEnabled = false
    }

    func login(code: String) {
        do {
            try viewModel.login(code: code)
        } catch {
            // TODO: Alert
            print(error)
        }
    }

    private func bind() {
        let input = LogInViewModel.Input(
            logInButtonDidTap: logInView.camperAuthButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.openLogInView
            .sink { [weak self] _ in
                self?.coordinatorPublisher.send(.moveToGithubLogIn)
            }
            .store(in: &cancelBag)

        output.moveToOtherView
            .sink { [weak self] logInEvent in
                self?.logInView.activityIndicator.stopAnimating()
                self?.logInView.loadingLabel.isHidden = true
                self?.logInView.camperAuthButton.isEnabled = true

                switch logInEvent {
                case .moveToDomainScreen:
                    self?.coordinatorPublisher.send(.moveToDomainScreen)
                case .moveToTabBarScreen:
                    self?.coordinatorPublisher.send(.moveToTabBarScreen)
                case .showAlert(let message):
                    self?.showAlert(message: message)
                case .moveToBlogScreen, .moveToIDScreen, .moveToGithubLogIn:
                    return
                }
            }
            .store(in: &cancelBag)
    }
}
