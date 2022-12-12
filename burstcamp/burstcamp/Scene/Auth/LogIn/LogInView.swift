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

    lazy var camperAuthButton: UIButton = {
        let button = UIButton()

        if #available(iOS 15.0, *) {
            var string = AttributedString("캠퍼 인증 시작하기")
            string.font = UIFont.extraBold14
            string.foregroundColor = .dynamicWhite

            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = string
            configuration.titleAlignment = .center

            configuration.image = UIImage.github
            configuration.imagePlacement = .leading
            configuration.imagePadding = 50

            configuration.baseBackgroundColor = .dynamicBlack
            configuration.cornerStyle = .medium

            button.configuration = configuration

            return button
        } else {
            button.setTitle("캠퍼 인증 시작하기", for: .normal)
            button.titleLabel?.font = UIFont.extraBold14
            button.setTitleColor(.dynamicWhite, for: .normal)
            button.titleLabel?.textAlignment = .center

            button.setImage(UIImage.github, for: .normal)

            button.backgroundColor = .dynamicBlack
            button.layer.cornerRadius = CGFloat(Constant.CornerRadius.radius8)

            return button
        }
    }()

    private lazy var camperAuthLabel: UILabel = UILabel().then {
        $0.text = "캠퍼 인증을 위해 Github으로 로그인을 해주세요."
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
    }

    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
    }

    lazy var loadingLabel: UILabel = UILabel().then {
        $0.text = "캠퍼 인증 중"
        $0.font = .bold12
        $0.textColor = .dynamicBlack
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
        addSubview(camperAuthButton)
        addSubview(camperAuthLabel)
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

        camperAuthButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.space16)
            $0.height.equalTo(Constant.Button.camperAuthButtonHeight)
            $0.bottom.equalToSuperview().multipliedBy(0.9)
        }

        camperAuthButton.imageView?.snp.makeConstraints {
            $0.trailing.equalToSuperview().multipliedBy(0.15)
            $0.centerY.equalToSuperview()
        }

        camperAuthButton.titleLabel?.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        camperAuthLabel.snp.makeConstraints {
            $0.top.equalTo(camperAuthButton.snp.bottom).offset(Constant.space12)
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
