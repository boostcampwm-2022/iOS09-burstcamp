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

    func showIndicator() {
        DispatchQueue.main.async {
            self.logInView.activityIndicator.startAnimating()
            self.logInView.loadingLabel.isHidden = false
            self.logInView.camperAuthButton.isEnabled = false
            self.setUserInteraction(isEnabled: false)
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async {
            self.logInView.activityIndicator.stopAnimating()
            self.logInView.loadingLabel.isHidden = true
            self.logInView.camperAuthButton.isEnabled = true
            self.setUserInteraction(isEnabled: true)
        }
    }

    func login(code: String) {
        Task { [weak self] in
            self?.showIndicator()
            do {
                try await self?.viewModel.login(code: code)
            } catch {
                self?.showAlert(message: error.localizedDescription)
            }
            self?.hideIndicator()
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
                case .moveToDomainScreen(let userNickname):
                    self?.coordinatorPublisher.send(.moveToDomainScreen(userNickname: userNickname))
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
