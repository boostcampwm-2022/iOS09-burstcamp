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

protocol LoginScreenFlow {
    func moveToTabBarFlow()
}

final class LoginViewController: UIViewController {
    private var loginView: LogInView {
        guard let view = view as? LogInView else { return LogInView() }
        return view
    }

    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    let viewModel: LogInViewModel

    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let logInView = LogInView()
        self.view = logInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        loginView.githubLogInButton.addTarget(
            self,
            action: #selector(loginButtonDidTap),
            for: .touchUpInside
        )
    }

    @objc private func loginButtonDidTap() {
        viewModel.logInButtonDidTap()
//        moveToTabBarFlow()
    }
}

extension LoginViewController: LoginScreenFlow {
    func moveToTabBarFlow() {
        coordinatorPublisher.send(.moveToTabBarFlow)
    }
}
