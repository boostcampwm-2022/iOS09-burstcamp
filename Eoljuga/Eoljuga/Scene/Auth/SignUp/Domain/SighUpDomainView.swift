//
//  DomainView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import UIKit

import SnapKit

final class SignUpDomainView: UIView {

    lazy var mainLabel: UILabel = UILabel().then {
        $0.text = "도메인을 선택해주세요"
        $0.font = UIFont.extraBold20
    }

    lazy var subLabel: UILabel = UILabel().then {
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
        backgroundColor = .systemBackground

        addSubview(mainLabel)
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(176)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(webButton)
        webButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(326)
        }

        addSubview(aosButton)
        aosButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(webButton.snp.bottom).offset(48)
        }

        addSubview(iosButton)
        iosButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(aosButton.snp.bottom).offset(48)
        }
    }
}
