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

    lazy var idTextField: UITextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.keyboardType = .numberPad
        $0.becomeFirstResponder()
        $0.placeholder = "000"
        $0.leftView = UIView.paddingView(self)()
        $0.rightView = UIView.paddingView(self)()
        $0.leftViewMode = .always
        $0.rightViewMode = .always
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

    private lazy var barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: nextButton)

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
            $0.top.equalToSuperview().offset(Constant.space176)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        addSubview(mainLabel)
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constant.space176)
            $0.leading.equalTo(domainLabel.snp.trailing).offset(Constant.space8)
        }

        addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constant.space8)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        addSubview(representingDomainLabel)
        representingDomainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constant.space288)
            $0.leading.equalToSuperview().offset(Constant.space24)
        }

        addSubview(idTextField)
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
