//
//  DefaultFeedCellMain.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

import SnapKit

class DefaultFeedCellMain: UIStackView {

    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor.black
        $0.font = UIFont.bold14
        $0.text = """
        hello world, hello world, hello world, hello world, hello world, hello world,
        hello world, hello world, hello world, hello world, hello world, hello world,
        """
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .hangulWordPriority
        label.numberOfLines = 3
    }

    lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constant.Image.thumbnailCornerRadius.cgFloat
        $0.backgroundColor = UIColor.systemGray2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureStackView()
        configureTitleLabel()
        configureThumbnailImageView()
    }

    private func configureStackView() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
        spacing = Constant.space8.cgFloat
    }

    private func configureTitleLabel() {
        addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints {
//            $0.height.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
    }

    private func configureThumbnailImageView() {
        addArrangedSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(Constant.Image.thumbnailWidth)
        }
    }
}
