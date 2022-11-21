//
//  CamperIDView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import UIKit

final class SignUpCamperIDView: UIView {

    lazy var domainLabel: UILabel = UILabel().then {
        $0.font = UIFont.extraBold20
    }

    lazy var mainLabel: UILabel = UILabel().then {
        $0.text = "캠퍼님 아이디를 입력해주세요"
        $0.font = UIFont.extraBold20
    }

    lazy var subLabel: UILabel = UILabel().then {
        $0.text = "세자리로 입력해주세요"
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
    }

    lazy var representingDomainLabel: UILabel = UILabel().then {
        $0.font = UIFont.extraBold16
    }

    lazy var idTextField: UITextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.keyboardType = .numberPad
        $0.becomeFirstResponder()
        $0.placeholder = "000"
        $0.inputAccessoryView = toolBar
    }

    lazy var toolBar: UIToolbar = UIToolbar().then {
        $0.items = [barButtonItem]
        $0.barTintColor = .white
        $0.clipsToBounds = true
        $0.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
    }

    lazy var barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: nextButton)

    lazy var nextButton: UIButton = DefaultButton(title: "다음")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    func configureUI() {
        backgroundColor = .systemBackground

        addSubview(domainLabel)
        domainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(176)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(mainLabel)
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(176)
            $0.leading.equalTo(domainLabel.snp.trailing).offset(8)
        }

        addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }

        addSubview(representingDomainLabel)
        representingDomainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(288)
            $0.leading.equalToSuperview().offset(24)
        }

        addSubview(idTextField)
        idTextField.snp.makeConstraints {
            $0.centerY.equalTo(representingDomainLabel.snp.centerY)
            $0.leading.equalTo(representingDomainLabel.snp.trailing).offset(12)
            $0.height.equalTo(50)
        }

        toolBar.snp.makeConstraints {
            $0.height.equalTo(72)
        }

        nextButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}
