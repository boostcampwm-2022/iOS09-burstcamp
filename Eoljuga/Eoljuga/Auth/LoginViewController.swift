//
//  LoginViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

import SnapKit

class LoginViewController: UIViewController {
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        return button
    }()

    var coordinatrPublisher = PassthroughSubject<CoordinatorEvent, Never>()

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

    @objc func loginButtonTouched() {
        moveToTabBarFlow()
    }
}

extension LoginViewController: CoordinatorPublisher {
    func moveToTabBarFlow() {
        coordinatrPublisher.send(.moveToTabBarFlow)
    }
}
