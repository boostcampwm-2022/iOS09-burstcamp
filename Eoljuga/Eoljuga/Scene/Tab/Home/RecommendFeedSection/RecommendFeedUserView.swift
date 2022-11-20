//
//  RecommendFeedUserView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/20.
//

import UIKit

final class RecommendFeedUserView: UIStackView {

    private lazy var profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Constant.Image.profileSmall.cgFloat / 2
        $0.image = UIImage(systemName: "square.fill")
        $0.contentMode = .scaleAspectFill
    }

    private lazy var nameLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = .bold12
        $0.text = "하늘이"
    }

    private lazy var blogNameLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = .regular8
        $0.text = "성이 하씨고 이름이 늘이, 성이 하씨고 이름이 늘이, 성이 하씨고 이름이 늘이"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addArrangedSubViews([profileImageView, nameLabel, blogNameLabel])
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
