//
//  DefaultFeedCellMain.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

import SnapKit

class NormalFeedCellMain: UIView {

    private lazy var titleLabel = DefaultMultiLineLabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor.dynamicBlack
        $0.font = UIFont.bold14
        $0.text = """
        [Swift 5.7+][Concurrency] AsyncStream, AsyncThrowingStream 알아보기 - Continuation vs unfoldin
        g [Swift 5.7+][Concurrency
        """
        $0.numberOfLines = 3
    }

    private lazy var thumbnailImageView = UIImageView().then {
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
        addSubViews([thumbnailImageView, titleLabel])
        configureThumbnailImageView()
        configureTitleLabel()
    }

    private func configureThumbnailImageView() {
        thumbnailImageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(Constant.Image.thumbnailWidth)
        }
    }

    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-Constant.space8)
        }
    }
}
