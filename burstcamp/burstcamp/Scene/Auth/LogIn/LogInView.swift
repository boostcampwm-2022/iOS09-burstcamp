//
//  LogInView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import UIKit

import SnapKit
import Then

final class LogInView: UIView {

    private lazy var titleImage: UIImageView = UIImageView().then {
        $0.image = UIImage.burstcamper
    }

    private lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "burstcamp"
        $0.font = UIFont.extraBold40
        $0.textColor = UIColor.main
    }

    private lazy var identitySentenceLabel: UILabel = UILabel().then {
        $0.text = "부스트 캠프, 또 하나의 이야기"
        $0.font = UIFont.regular14
    }

    lazy var githubLogInButton: UIButton = UIButton().then {
        $0.setTitle("Github으로 로그인", for: .normal)
        $0.titleLabel?.font = UIFont.extraBold14
        $0.backgroundColor = .dynamicBlack
        $0.setTitleColor(.dynamicWhite, for: .normal)
        $0.layer.cornerRadius = CGFloat(Constant.CornerRadius.radius8)
    }

    private lazy var githubLogInLabel: UILabel = UILabel().then {
        $0.text = "캠퍼 인증을 위해 Github으로 로그인을 해주세요."
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
    }

    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .large
    }

    lazy var loadingLabel: UILabel = UILabel().then {
        $0.text = "캠퍼 인증 중"
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        backgroundColor = .background
        addViews()
        configureLayout()
    }

    private func addViews() {
        addSubview(titleImage)
        addSubview(titleLabel)
        addSubview(identitySentenceLabel)
        addSubview(githubLogInButton)
        addSubview(githubLogInLabel)
        addSubview(activityIndicator)
        addSubview(loadingLabel)
    }

    private func configureLayout() {
        titleImage.snp.makeConstraints {
            $0.height.width.equalTo(Constant.Image.appTitle)
            $0.centerY.equalToSuperview().offset(Constant.spaceMinus72)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleImage.snp.trailing)
            $0.centerY.equalToSuperview().offset(Constant.spaceMinus72)
        }

        identitySentenceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.space10)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        githubLogInButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.space16)
            $0.height.equalTo(Constant.Button.githubLogInButtonHeight)
            $0.bottom.equalToSuperview().multipliedBy(0.9)
        }

        githubLogInLabel.snp.makeConstraints {
            $0.top.equalTo(githubLogInButton.snp.bottom).offset(Constant.space12)
            $0.centerX.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom).offset(Constant.space10)
        }
    }
}
