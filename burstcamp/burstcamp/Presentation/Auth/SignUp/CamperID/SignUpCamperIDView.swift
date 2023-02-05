//
//  CamperIDView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class SignUpCamperIDView: UIView {

    lazy var domainLabel: UILabel = UILabel().then {
        $0.font = UIFont.extraBold20
    }

    private lazy var mainLabel: UILabel = UILabel().then {
        $0.text = "캠퍼님 아이디를 입력해주세요"
        $0.font = UIFont.extraBold20
    }

    private lazy var subLabel: UILabel = UILabel().then {
        $0.text = "세자리로 입력해주세요"
        $0.font = UIFont.regular12
        $0.textColor = .systemGray2
    }

    lazy var representingDomainLabel: UILabel = UILabel().then {
        $0.font = UIFont.extraBold16
    }

    lazy var idTextField: UITextField = DefaultTextField(placeholder: "000").then {
        $0.keyboardType = .numberPad
        $0.becomeFirstResponder()
        $0.inputAccessoryView = toolBar
    }

    private lazy var toolBar: UIToolbar = UIToolbar().then {
        $0.items = [barButtonItem]
        $0.barTintColor = .dynamicWhite
        $0.clipsToBounds = true
        $0.layoutMargins = .init(
            top: CGFloat(Constant.space12),
            left: CGFloat(Constant.space16),
            bottom: CGFloat(Constant.space12),
            right: CGFloat(Constant.space16)
        )
    }

    private lazy var barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: nextButton).then {
        $0.isEnabled = false
    }

    lazy var nextButton = DefaultButton(title: "다음").then {
        $0.alpha = 0.3
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    func configureUI() {
        backgroundColor = .background
        addViews()
        configureLayout()
    }

    private func addViews() {
        addSubview(domainLabel)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(representingDomainLabel)
        addSubview(idTextField)
    }

    private func configureLayout() {
        domainLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().multipliedBy(0.2)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        mainLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().multipliedBy(0.2)
            $0.leading.equalTo(domainLabel.snp.trailing).offset(Constant.space8)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constant.space8)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        representingDomainLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().multipliedBy(0.35)
            $0.leading.equalToSuperview().offset(Constant.space24)
        }

        idTextField.snp.makeConstraints {
            $0.centerY.equalTo(representingDomainLabel.snp.centerY)
            $0.leading.equalTo(representingDomainLabel.snp.trailing).offset(Constant.space12)
            $0.height.equalTo(Constant.TextField.camperIDHeight)
        }

        toolBar.snp.makeConstraints {
            $0.height.equalTo(Constant.ToolBar.height)
        }

        nextButton.snp.makeConstraints {
            $0.height.equalTo(Constant.space48)
        }
    }
}
