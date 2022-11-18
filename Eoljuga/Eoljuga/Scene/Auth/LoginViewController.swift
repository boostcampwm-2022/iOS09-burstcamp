//
//  LoginViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

import SnapKit

protocol LoginScreenFlow {
    func moveToTabBarFlow()
}

class LoginViewController: UIViewController {
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        return button
    }()

    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        configureLoginButton()
    }

    func configureLoginButton() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.center.equalToSuperview()
        }
    }

    @objc func loginButtonDidTap() {
        moveToTabBarFlow()
    }
}

extension LoginViewController: LoginScreenFlow {
    func moveToTabBarFlow() {
        coordinatorPublisher.send(.moveToTabBarFlow)
    }
}
