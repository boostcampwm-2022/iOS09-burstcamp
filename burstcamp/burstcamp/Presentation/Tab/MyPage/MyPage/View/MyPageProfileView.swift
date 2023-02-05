//
//  MyPageProfileView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class MyPageProfileView: UIView {

    // MARK: - Properties

    private let profileImageView = DefaultProfileImageView(
        imageSize: Constant.Image.profileMedium
    )

    private lazy var profileInfoStackView = UIStackView(
        views: [nicknameLabel],
        spacing: Constant.space6
    )

    private let nicknameLabel = UILabel().then {
        $0.textColor = .dynamicBlack
        $0.font = .extraBold16
    }

    private let userBadgeView = DefaultBadgeView()

    private let blogTitleLabel = DefaultImageLabel(
        icon: UIImage(systemName: "book.fill"),
        text: "블로그를 등록해주세요."
    )

    private let guestBadgeView = DefaultBadgeLabel(
        textColor: Domain.guest.color
    )

    private var isConfigured = false

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
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constant.space16)
            make.width.height.equalTo(Constant.Image.profileMedium)
            make.centerY.equalToSuperview()
        }

        addSubview(profileInfoStackView)

        profileInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(Constant.space16)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - 유저 프로필 사진 업데이트

    private func updateUserProfileImage(user: User) {
        guard user.domain != .guest else { return }
        profileImageView.setImage(urlString: user.profileImageURL, isDiskCaching: true)
    }

    // MARK: - 유저 Info 업데이트

    private func configureProfileInfoView(domain: Domain) {
        guard !isConfigured else { return }
        if domain == .guest {
            profileInfoStackView.addArrangedSubview(guestBadgeView)
            profileInfoStackView.alignment = .leading
        } else {
            profileInfoStackView.addArrangedSubViews([userBadgeView, blogTitleLabel])
        }

        isConfigured = true
    }

    private func updateProfileInfoView(user: User) {
        configureProfileInfoView(domain: user.domain)
        if user.domain == .guest {
            guestBadgeView.updateView(text: user.domain.representing)
        } else {
            userBadgeView.updateView(user: user)
            blogTitleLabel.updateBlogImageLabel(user: user)
        }
    }
}

extension MyPageProfileView {
    func updateView(user: User) {
        updateUserProfileImage(user: user)
        nicknameLabel.text = user.nickname
        updateProfileInfoView(user: user)
    }
}
