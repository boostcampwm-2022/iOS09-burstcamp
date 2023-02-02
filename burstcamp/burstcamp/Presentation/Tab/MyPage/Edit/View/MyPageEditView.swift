//
//  MyPageEditView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class MyPageEditView: UIView {

    // MARK: - Properties

    lazy var profileImageView = DefaultProfileImageView(
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

    private let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .dynamicBlack
        $0.font = .bold14
    }

    private let nickNameTextField = DefaultTextField(
        placeholder: "닉네임을 입력해주세요. (한, 영, 숫자, _, -, 2-10자)",
        clearButton: true
    )

    private let nickNameDescriptionLabel = DefaultPaddingLabel(horizontalPadding: 6).then {
        $0.text = "닉네임 조건에 맞지 않아요. (한, 영, 숫자, _, -, 2-10자)"
        $0.font = .regular10
    }

    private lazy var nickNameStackView = UIStackView(
        views: [nickNameLabel, nickNameTextField, nickNameDescriptionLabel],
        spacing: Constant.space8
    )

    private let blogLinkLabel = UILabel().then {
        $0.text = "블로그 주소"
        $0.textColor = .dynamicBlack
        $0.font = .bold14
    }

    private let blogLinkTextField = DefaultTextField(
        placeholder: "블로그 주소를 입력해주세요.",
        clearButton: true
    )

    private var blogTitleImageLabel = DefaultImageLabel(
        icon: UIImage(systemName: ""),
        text: ""
    )

    private lazy var blogLinkStackView = UIStackView(
        views: [blogLinkLabel, blogLinkTextField, blogTitleImageLabel],
        spacing: Constant.space8
    )

    lazy var editStackView = UIStackView(
        views: [nickNameStackView, blogLinkStackView, finishEditButton],
        spacing: Constant.space48
    )

    private let finishEditButton = DefaultButton(title: "수정완료").then {
        $0.backgroundColor = .systemGray2
        $0.isEnabled = false
    }

    private let descriptionLabel = UILabel().then {
        $0.text = "유저 정보는 30일에 1회 수정이 가능해요"
        $0.textColor = .systemGray2
        $0.font = .regular12
    }

    lazy var cameraButtonTapPublisher = cameraButton.tapPublisher
    lazy var nickNameTextFieldTextPublisher = nickNameTextField.textPublisher
    lazy var blogLinkTextFieldTextPublisher = blogLinkTextField.textPublisher
    lazy var finishEditButtonTapPublisher = finishEditButton.tapPublisher

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
            make.width.height.equalTo(profileImageView.imageSize)
        }

        addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.width.height.equalTo(Constant.Button.camera)
        }

        finishEditButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.Button.defaultButton)
        }

        nickNameTextField.snp.makeConstraints { make in
            make.height.equalTo(Constant.TextField.camperIDHeight)
        }

        blogLinkTextField.snp.makeConstraints { make in
            make.height.equalTo(Constant.TextField.camperIDHeight)
        }

        addSubview(editStackView)
        editStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Constant.space48)
            make.horizontalEdges.equalToSuperview().inset(Constant.space16)
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(editStackView.snp.bottom).offset(Constant.space12)
            make.horizontalEdges.equalToSuperview().inset(Constant.space16)
        }
    }
}

extension MyPageEditView {
    func updateCurrentUserInfo(user: User) {
        DispatchQueue.main.async {
            self.profileImageView.setImage(urlString: user.profileImageURL, isDiskCaching: true)
            self.nickNameTextField.text = user.nickname
            self.blogLinkTextField.text = user.blogURL
            self.blogTitleImageLabel = DefaultImageLabel(
                icon: UIImage(systemName: "book.fill"),
                text: user.blogTitle
            )
        }
    }

    func updateNickNameDescriptionLabel(text: String, textColor: UIColor) {
        DispatchQueue.main.async {
            self.nickNameDescriptionLabel.text = text
            self.nickNameDescriptionLabel.textColor = textColor
        }
    }

    func enableEditButton() {
        DispatchQueue.main.async {
            self.finishEditButton.isEnabled = true
            self.finishEditButton.backgroundColor = .main
        }
    }

    func disableEditButton() {
        DispatchQueue.main.async {
            self.finishEditButton.isEnabled = false
            self.finishEditButton.backgroundColor = .systemGray5
        }
    }
}
