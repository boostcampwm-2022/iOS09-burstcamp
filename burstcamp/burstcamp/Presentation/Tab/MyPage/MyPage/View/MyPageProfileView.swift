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

    private let nicknameLabel = UILabel().then {
        $0.textColor = .dynamicBlack
        $0.font = .extraBold16
    }

    private let badgeView = DefaultBadgeView()

    private let blogTitleLabel = DefaultImageLabel(
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
            views: [nicknameLabel, badgeView, blogTitleLabel])
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
        print("얼마나 마이페이지가 업데이트 되나?", #function)
        profileImageView.setImage(urlString: user.profileImageURL, isDiskCaching: true)
        nicknameLabel.text = user.nickname
        badgeView.updateView(user: user)
        blogTitleLabel.updateBlogImageLabel(user: user)
    }
}
