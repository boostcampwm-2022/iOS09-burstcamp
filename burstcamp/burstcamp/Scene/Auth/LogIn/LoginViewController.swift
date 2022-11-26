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
    var cancelBag = Set<AnyCancellable>()

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
        logInView.githubLogInButton.addTarget(
            self,
            action: #selector(loginButtonDidTap),
            for: .touchUpInside
        )

        LogInManager.shared.logInPublisher
            .sink { logInEvent in
                switch logInEvent {
                case .moveToDomainScreen:
                    self.coordinatorPublisher.send(.moveToDomainScreen)
                case .moveToTabBarScreen:
                    self.coordinatorPublisher.send(.moveToTabBarScreen)
                case .moveToBlogScreen, .moveToIDScreen:
                    return
                }
            }
            .store(in: &cancelBag)
    }

    @objc private func loginButtonDidTap() {
        viewModel.logInButtonDidTap()
    }
}
