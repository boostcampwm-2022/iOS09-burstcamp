//
//  RecommendFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import UIKit

import SkeletonView
import SnapKit

final class RecommendFeedCell: UICollectionViewCell {

    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = Constant.space24.cgFloat
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

    override func prepareForReuse() {
        super.prepareForReuse()
        userView.resetUserImage()
    }

    private func configureUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubViews([titleLabel, userView])
        configureCell()
        configureSkeleton()
        configureStackView()
    }

    private func configureCell() {
        layer.cornerRadius = Constant.space24.cgFloat
    }

    private func configureSkeleton() {
        isSkeletonable = true
        skeletonCornerRadius = Constant.space24.float
    }

    private func configureStackView() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setUserInteractionEnabled(url: String) {
        if url.isEmpty {
            isUserInteractionEnabled = false
        } else {
            isUserInteractionEnabled = true
        }
    }
}

extension RecommendFeedCell {
    func updateFeedCell(with feed: Feed) {
        setUserInteractionEnabled(url: feed.url)
        titleLabel.text = feed.title
        userView.updateView(feedWriter: feed.writer)
        backgroundColor = feed.writer.domain.brightColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.3
    }
}
