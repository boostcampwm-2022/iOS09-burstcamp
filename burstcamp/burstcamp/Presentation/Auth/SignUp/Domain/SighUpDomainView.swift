//
//  DomainView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class SignUpDomainView: UIView {

    private lazy var mainLabel: UILabel = UILabel().then {
        $0.text = "도메인을 선택해주세요"
        $0.font = UIFont.extraBold20
    }

    private lazy var subLabel: UILabel = UILabel().then {
        $0.text = "부스트캠프 7기 수료 도메인을 선택해주세요"
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
    }

    lazy var webButton: UIButton = DefaultButton(
        title: Domain.web.rawValue,
        font: .extraBold16,
        backgroundColor: .systemGray5
    )

    lazy var aosButton: UIButton = DefaultButton(
        title: Domain.android.rawValue,
        font: .extraBold16,
        backgroundColor: .systemGray5
    )

    lazy var iosButton: UIButton = DefaultButton(
        title: Domain.iOS.rawValue,
        font: .extraBold16,
        backgroundColor: .systemGray5
    )

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
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(webButton)
        addSubview(aosButton)
        addSubview(iosButton)
    }

    private func configureLayout() {
        mainLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().multipliedBy(0.2)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constant.space8)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        webButton.snp.makeConstraints {
            $0.width.equalTo(Constant.Button.domainWidth)
            $0.height.equalTo(Constant.Button.domainHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().multipliedBy(0.45)
        }

        aosButton.snp.makeConstraints {
            $0.width.equalTo(Constant.Button.domainWidth)
            $0.height.equalTo(Constant.Button.domainHeight)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(webButton.snp.bottom).offset(Constant.space48)
        }

        iosButton.snp.makeConstraints {
            $0.width.equalTo(Constant.Button.domainWidth)
            $0.height.equalTo(Constant.Button.domainHeight)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(aosButton.snp.bottom).offset(Constant.space48)
        }
    }
}
