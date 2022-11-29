//
//  FeedDetailView.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import UIKit
import WebKit

import SnapKit
import Then

final class FeedDetailView: UIView {

    private lazy var userInfoStackView = DefaultUserInfoView()

    private lazy var feedInfoStackView = UIStackView().then {
        $0.addArrangedSubViews([titleLabel, blogTitleLabel, pubDateLabel])
        $0.axis = .vertical
        $0.spacing = Constant.space6.cgFloat
    }

    private lazy var titleLabel = DefaultMultiLineLabel().then {
        $0.font = .extraBold16
        $0.textColor = .dynamicBlack
        $0.numberOfLines = 3
    }

    private lazy var blogTitleLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .systemGray2
    }

    private lazy var pubDateLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .dynamicBlack
    }

    private lazy var contentView = FeedContentWebView()

    private lazy var blogButton = DefaultButton(title: "블로그 바로가기")
    lazy var blogButtonTapPublisher = blogButton.tapPublisher

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        fetchMockData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .background
        addSubViews([userInfoStackView, feedInfoStackView, contentView, blogButton])

        blogButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Constant.space12)
            $0.height.equalTo(Constant.Button.defaultButton)
        }

        userInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.trailing.lessThanOrEqualToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(safeAreaLayoutGuide).inset(Constant.space12)
        }

        feedInfoStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(Constant.space24)
        }

        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(feedInfoStackView.snp.bottom).offset(Constant.space24)
            $0.bottom.equalTo(blogButton.snp.top).offset(-Constant.space12)
        }
    }
}

extension FeedDetailView {

    private func fetchMockData() {
        titleLabel.text = "[SwiftUI] NavigationView ➡️ NavigationStack"
        blogTitleLabel.text = "Zedd"
        pubDateLabel.text = "2022. 11. 20. 17:38"
        contentView.loadFormattedHTMLString(String.htmlReadability)
    }
}
