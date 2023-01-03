//
//  DefaultUserInfoView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

import SnapKit

class DefaultUserInfoView: UIStackView {

    private lazy var profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Constant.Image.profileSmall.cgFloat / 2
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
    }

    private lazy var nameLabel = UILabel().then {
        $0.textColor = UIColor.systemGray
        $0.font = UIFont.extraBold12
        $0.text = ""
    }

    private lazy var badgeStackView = DefaultBadgeView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addArrangedSubViews([profileImageView, nameLabel, badgeStackView])
        configureStackView()
        configureProfileImageView()
    }

    private func configureStackView() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = Constant.space8.cgFloat
        isLayoutMarginsRelativeArrangement = true
    }

    private func configureProfileImageView() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constant.Image.profileSmall)
        }
    }
}

extension DefaultUserInfoView {
    // TODO: User와 FeedWriter에 상위 프로토콜을 만들어 함수를 하나로
    func updateView(user: User) {
        DispatchQueue.main.async {
            self.nameLabel.text = user.nickname
        }
        profileImageView.setImage(urlString: user.profileImageURL)
        badgeStackView.updateView(user: user)
    }

    func updateView(feedWriter: FeedWriter) {
        DispatchQueue.main.async {
            self.nameLabel.text = feedWriter.nickname
        }
        profileImageView.setImage(urlString: feedWriter.profileImageURL)
        badgeStackView.updateView(feedWriter: feedWriter)
    }

    func reset() {
        DispatchQueue.main.async {
            self.nameLabel.text = ""
            self.profileImageView.image = nil
            self.badgeStackView.reset()
        }
    }
}
