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
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
    }

    private lazy var nicknameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .bold12
    }

    private lazy var blogTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .regular8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addArrangedSubViews([profileImageView, nicknameLabel, blogTitleLabel])
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

extension RecommendFeedUserView {
    func updateView(feedWriter: FeedWriter) {
        profileImageView.setImage(urlString: feedWriter.profileImageURL)
        nicknameLabel.text = feedWriter.nickname
        blogTitleLabel.text = feedWriter.blogTitle
    }
}
