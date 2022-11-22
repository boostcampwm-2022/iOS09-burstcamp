//
//  MyPageProfileView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class MyPageProfileView: UIView {

    // MARK: - Properties

    private let user: User!

    private lazy var profileImageView = DefaultProfileImageView(
        imageSize: Constant.Image.profileMedium
        // TODO: set user Image
    )

    private lazy var nickNameLabel = UILabel().then {
        $0.text = user.name
        $0.textColor = .dynamicBlack
        $0.font = .extraBold16
    }

    private lazy var badgeView = DefaultBadgeView(user: user)

    private lazy var blogTitleLabel = UILabel().then {
        // TODO: set Blog Title
        $0.text = "성이 하씨고 이름이 늘이"
        $0.textColor = .systemGray
        $0.font = .regular12
    }

    // MARK: - Initializer

    init(user: User) {
        self.user = user
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
        return UIStackView(arrangedSubviews: views).then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .fill
            $0.spacing = Constant.space6.cgFloat
        }
    }
}
