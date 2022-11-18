//
//  LogInView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import UIKit

final class LogInView: UIView {

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
    }

    lazy var githubLogInLabel: UILabel = UILabel().then {
        $0.text = "캠퍼 인증을 위해 Github으로 로그인을 해주세요."
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
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
        backgroundColor = .systemBackground

        addSubview(bossImage)
        bossImage.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.centerY.equalToSuperview().offset(-72)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(bossTitleL)
        bossTitleL.snp.makeConstraints {
            $0.leading.equalTo(bossImage.snp.trailing)
            $0.centerY.equalToSuperview().offset(-72)
        }

        addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints {
            $0.top.equalTo(bossImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(identitySentence)
        identitySentence.snp.makeConstraints {
            $0.top.equalTo(fullNameLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(githubLogInLabel)
        githubLogInLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-88)
            $0.centerX.equalToSuperview()
        }

        addSubview(githubLogInButton)
        githubLogInButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalTo(githubLogInLabel.snp.top).offset(-12)
        }
    }
}
