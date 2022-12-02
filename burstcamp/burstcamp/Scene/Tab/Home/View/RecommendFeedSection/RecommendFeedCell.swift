//
//  RecommendFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import UIKit

import SnapKit

final class RecommendFeedCell: UICollectionViewCell {

    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = Constant.space12.cgFloat
    }

    private lazy var titleLabel = DefaultMultiLineLabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor.black
        $0.font = UIFont.extraBold16
        $0.text = ""
        $0.numberOfLines = 3
    }

    private lazy var userView = RecommendFeedUserView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        addSubview(stackView)
        stackView.addArrangedSubViews([titleLabel, userView])
        configureCell()
        configureStackView()
    }

    private func configureCell() {
        backgroundColor = .customGreen
        layer.cornerRadius = Constant.space24.cgFloat
    }

    private func configureStackView() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension RecommendFeedCell {
    func updateView(with feed: Feed) {
        titleLabel.text = feed.feedTitle
        userView.updateView(feedWriter: feed.writer)
        backgroundColor = feed.writer.domain.color
    }
}
