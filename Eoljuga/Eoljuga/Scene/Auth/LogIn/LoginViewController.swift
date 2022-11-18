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

    lazy var bossImage: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "pencil.circle")
    }

    lazy var bossTitleL: UILabel = UILabel().then {
        $0.text = "BOSS"
        $0.font = UIFont.extraBold40
        $0.textColor = UIColor.main
    }

    lazy var fullNameLabel: UILabel = UILabel().then {
        $0.text = "Boostcamp Other StorieS"
        $0.font = UIFont.bold12
        $0.textColor = .systemGray2
    }

    lazy var identitySentence: UILabel = UILabel().then {
        $0.text = "부스트 캠프, 또 하나의 이야기"
        $0.font = UIFont.bold20
    }

    lazy var githubLogInButton: UIButton = UIButton().then {
        $0.setTitle("Github으로 로그인", for: .normal)
        $0.titleLabel?.font = UIFont.extraBold14
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    lazy var githubLogInLabel: UILabel = UILabel().then {
        $0.text = "캠퍼 인증을 위해 Github으로 로그인을 해주세요."
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
    }

    var coordinatrPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    let viewModel: LogInViewModel = LogInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(bossImage)
        bossImage.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.centerY.equalToSuperview().offset(-72)
            $0.leading.equalToSuperview().offset(16)
        }

        view.addSubview(bossTitleL)
        bossTitleL.snp.makeConstraints {
            $0.leading.equalTo(bossImage.snp.trailing)
            $0.centerY.equalToSuperview().offset(-72)
        }

        view.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints {
            $0.top.equalTo(bossImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }

        view.addSubview(identitySentence)
        identitySentence.snp.makeConstraints {
            $0.top.equalTo(fullNameLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }

        view.addSubview(githubLogInLabel)
        githubLogInLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-88)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(githubLogInButton)
        githubLogInButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalTo(githubLogInLabel.snp.top).offset(-12)
        }
    }

    @objc private func loginButtonDidTap() {
        viewModel.logInButtonDidTap()
//        moveToTabBarFlow()
    }
}

extension LoginViewController: LoginScreenFlow {
    func moveToTabBarFlow() {
        coordinatrPublisher.send(.moveToTabBarFlow)
    }
}
