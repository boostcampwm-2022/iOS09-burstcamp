//
//  SignUpBlogView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/20.
//

import UIKit

import SnapKit
import Then

final class SignUpBlogView: UIView {

    private lazy var mainLabel: UILabel = UILabel().then {
        $0.text = "블로그 주소를 입력해주세요"
        $0.font = UIFont.extraBold20
    }

    private lazy var subLabel: UILabel = UILabel().then {
        $0.text = "주소는 추후에 추가/수정할 수 있어요\n현재는 Tistory, Velog만 지원 중 이에요"
        $0.font = UIFont.regular12
        $0.numberOfLines = 2
        $0.setLineHeight160()
        $0.textColor = .systemGray2
    }

    lazy var blogTextField: UITextField = DefaultTextField(
        placeholder: "https://luen.tistory.com"
    ).then {
        $0.keyboardType = .URL
        $0.becomeFirstResponder()
        $0.inputAccessoryView = toolBar
    }

    lazy var skipButton: UIButton = UIButton().then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(.customIndigo, for: .normal)
        $0.titleLabel?.font = UIFont.bold12
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

    lazy var nextButton: UIButton = DefaultButton(title: "다음").then {
        $0.alpha = 0.3
    }

    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
    }

    lazy var confirmBlogLabel: UILabel = UILabel().then {
        $0.text = "블로그 주소 검증 중"
        $0.isHidden = true
    }

    lazy var signUpLabel: UILabel = UILabel().then {
        $0.text = "가입 중"
        $0.font = .bold12
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        backgroundColor = .background
        addViews()
        configureLayout()
    }

    private func addViews() {
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(blogTextField)
        addSubview(skipButton)
        addSubview(activityIndicator)
        addSubview(confirmBlogLabel)
        addSubview(signUpLabel)
    }

    private func configureLayout() {
        mainLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().multipliedBy(0.2)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constant.space10)
            $0.leading.equalToSuperview().offset(Constant.space16)
        }

        blogTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.space24)
            $0.height.equalTo(Constant.TextField.camperIDHeight)
            $0.top.equalTo(subLabel.snp.bottom).offset(Constant.space32)
        }

        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constant.space24)
            $0.top.equalTo(blogTextField.snp.bottom).offset(Constant.space8)
        }

        toolBar.snp.makeConstraints {
            $0.height.equalTo(Constant.ToolBar.height)
        }

        nextButton.snp.makeConstraints {
            $0.height.equalTo(Constant.space48)
        }

        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        confirmBlogLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom).offset(Constant.space10)
        }

        signUpLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom).offset(Constant.space10)
        }
    }
}
