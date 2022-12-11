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
    }

    private func moveToGithubLogIn() {
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
        self.present(safariViewController, animated: true)
    }

    private func bind() {
        let input = LogInViewModel.Input(
            logInButtonDidTap: logInView.camperAuthButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.openLogInView
            .sink {
                self.moveToGithubLogIn()
            }
            .store(in: &cancelBag)

        output.moveToOtherView
            .sink { logInEvent in
                self.logInView.activityIndicator.stopAnimating()
                self.logInView.loadingLabel.isHidden = true

                switch logInEvent {
                case .moveToDomainScreen:
                    self.coordinatorPublisher.send(.moveToDomainScreen)
                case .moveToTabBarScreen:
                    self.coordinatorPublisher.send(.moveToTabBarScreen)
                case .showAlert(let message):
                    self.showAlert(message: message)
                case .moveToBlogScreen, .moveToIDScreen:
                    return
                }
            }
            .store(in: &cancelBag)
    }
}
