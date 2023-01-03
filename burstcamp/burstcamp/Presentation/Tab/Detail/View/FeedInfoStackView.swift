//
//  FeedInfoStackView.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import UIKit

final class FeedInfoStackView: UIStackView {

    private let titleLabel = DefaultMultiLineLabel().then {
        $0.font = .extraBold16
        $0.textColor = .dynamicBlack
        $0.numberOfLines = 3
    }

    private let blogTitleLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .systemGray2
    }

    private let pubDateLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .dynamicBlack
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        axis = .vertical
        spacing = Constant.space6.cgFloat
        alignment = .fill
        distribution = .equalSpacing
    }

    private func configureUI() {
        addArrangedSubViews([titleLabel, blogTitleLabel, pubDateLabel])
    }
}

extension FeedInfoStackView {
    func updateView(feed: Feed) {
        titleLabel.text = feed.title
        blogTitleLabel.text = feed.writer.blogTitle
        pubDateLabel.text = feed.pubDate.monthDateFormatString
    }
}
