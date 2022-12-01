//
//  MyPageProfileView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class MyPageProfileView: UIView {

    // MARK: - Properties

    private lazy var profileImageView = DefaultProfileImageView(
        imageSize: Constant.Image.profileMedium
    )

    private lazy var nickNameLabel = UILabel().then {
        $0.textColor = .dynamicBlack
        $0.font = .extraBold16
    }

    private lazy var badgeView = DefaultBadgeView()

    private lazy var blogTitleLabel = DefaultImageLabel(
        icon: UIImage(systemName: "book.fill"),
        text: "블로그를 등록해주세요."
    )

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

        let profileInfoStackView = profileInfoStackView(
            views: [nickNameLabel, badgeView, blogTitleLabel])
        addSubview(profileInfoStackView)
        profileInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(Constant.space16)
            make.centerY.equalToSuperview()
        }
    }

    private func profileInfoStackView(views: [UIView]) -> UIStackView {
        return UIStackView(
            views: views,
            spacing: Constant.space6
        )
    }

    func updateView(user: User) {
        profileImageView.setImage(urlString: user.profileImageURL)
        print(#function)
        print(user)
        print(user.nickname)
        nickNameLabel.text = user.nickname
        badgeView.updateView(user: user)
        blogTitleLabel = DefaultImageLabel(
            icon: UIImage(systemName: "book.fill"),
            text: user.blogTitle
        )
    }
}
