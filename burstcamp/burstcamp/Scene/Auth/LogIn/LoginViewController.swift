//
//  LoginViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
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

    private func bind() {
        let input = LogInViewModel.Input(
            logInButtonDidTap: logInView.githubLogInButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.openLogInView
            .sink {
                LogInManager.shared.openGithubLoginView()
            }
            .store(in: &cancelBag)

        output.moveToOtherView
            .sink { logInEvent in
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
