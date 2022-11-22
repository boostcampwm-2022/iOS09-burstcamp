//
//  MyPageEditView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class MyPageEditView: UIView {

    // MARK: - Properties

    private lazy var profileImageView = DefaultProfileImageView(
        imageSize: Constant.Image.profileLarge
    )

    private let configuration = UIImage.SymbolConfiguration(
        pointSize: Constant.Icon.camera.cgFloat
    )
    private lazy var cameraIcon = UIImage(
        systemName: "camera.fill",
        withConfiguration: configuration
    )?
        .withTintColor(.dynamicWhite, renderingMode: .alwaysOriginal)

    private lazy var cameraButton = UIButton().then {
        $0.setImage(cameraIcon, for: .normal)
        $0.backgroundColor = .main
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.dynamicWhite.cgColor
        $0.layer.cornerRadius = (Constant.Button.camera / 2).cgFloat
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
    }

    private lazy var nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .dynamicBlack
        $0.font = .bold14
    }

    private let nickNameTextField = DefaultTextField(
        placeholder: "닉네임을 입력해주세요."
    )

    private lazy var blogLinkLabel = UILabel().then {
        $0.text = "블로그 주소"
        $0.textColor = .dynamicBlack
        $0.font = .bold14
    }

    private let blogLinkChangeButton = DefaultButton(
        title: "변경",
        font: .bold14
    )

    private lazy var blogLinkTextField = DefaultTextField(
        placeholder: "블로그 주소를 입력해주세요."
    ).then {
        $0.rightView = blogLinkChangeButton
        $0.rightViewMode = .always
    }

    private let blogTitleImageLabel = DefaultImageLabel(
        icon: UIImage(systemName: "book.fill"),
        text: "말차맛 개발공부"
    )

    private lazy var finishEditButton = DefaultButton(title: "수정완료")

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func configureUI() {
        backgroundColor = .background

        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constant.space32)
            make.centerX.equalToSuperview()
            make.width.equalTo(profileImageView.imageSize)
            make.height.equalTo(profileImageView.imageSize)
        }

        addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.width.equalTo(Constant.Button.camera)
            make.height.equalTo(Constant.Button.camera)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }

        finishEditButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.Button.defaultButton)
        }

        nickNameTextField.snp.makeConstraints { make in
            make.height.equalTo(Constant.TextField.camperIDHeight)
        }

        let nickNameStackView = stackView(
            views: [nickNameLabel, nickNameTextField],
            spacing: Constant.space8
        )

        blogLinkTextField.snp.makeConstraints { make in
            make.height.equalTo(Constant.TextField.camperIDHeight)
        }

        blogLinkChangeButton.snp.makeConstraints { make in
            make.width.equalTo(Constant.Button.blogLinkChangeWidth)
            make.height.equalTo(Constant.Button.blogLinkChangeHeight)
        }

        let blogLinkStackView = stackView(
            views: [blogLinkLabel, blogLinkTextField, blogTitleImageLabel],
            spacing: Constant.space8
        )

        let editStackView = stackView(
            views: [nickNameStackView, blogLinkStackView, finishEditButton],
            spacing: Constant.space48
        )
        addSubview(editStackView)
        editStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Constant.space48)
            make.horizontalEdges.equalToSuperview().inset(Constant.space16)
        }
    }

    private func stackView(
        views: [UIView],
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .equalSpacing,
        alignment: UIStackView.Alignment = .fill,
        spacing: Int
    ) -> UIStackView {
        return UIStackView(arrangedSubviews: views).then {
            $0.axis = axis
            $0.distribution = distribution
            $0.alignment = alignment
            $0.spacing = spacing.cgFloat
        }
    }
}
