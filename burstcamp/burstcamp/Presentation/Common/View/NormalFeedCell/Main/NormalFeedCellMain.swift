//
//  DefaultFeedCellMain.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

import SkeletonView
import SnapKit

class NormalFeedCellMain: UIView {

    private lazy var titleLabel = DefaultMultiLineLabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor.dynamicBlack
        $0.font = UIFont.bold14
        $0.numberOfLines = 3
        $0.isSkeletonable = true
        $0.linesCornerRadius = Constant.CornerRadius.radius4
    }

    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Constant.Image.thumbnailCornerRadius.cgFloat
        $0.backgroundColor = UIColor.systemGray5
        $0.isSkeletonable = true
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

    // MARK: - 초기화 시 Constraints 설정

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

    // MARK: - Image 업데이트 시 설정

    private func updateThumbnailImageView() {
        thumbnailImageView.snp.updateConstraints {
            $0.width.equalTo(Constant.Image.thumbnailWidth)
        }
    }

    private func updateEmptyImageView() {
        thumbnailImageView.snp.updateConstraints {
            $0.width.equalTo(0)
        }
    }

    private func updateTitleLabel() {
        titleLabel.snp.updateConstraints {
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-Constant.space8)
        }
    }

    private func updateTitleLabelWithEmptyImageView() {
        titleLabel.snp.updateConstraints {
            $0.trailing.equalTo(thumbnailImageView.snp.leading)
        }
    }

    private func setThumbnailImage(urlString: String) {
        if urlString.isEmpty {
            updateEmptyImageView()
            updateTitleLabelWithEmptyImageView()
        } else {
            updateThumbnailImageView()
            updateTitleLabel()
            self.thumbnailImageView.setImage(urlString: urlString)
        }
    }
}

extension NormalFeedCellMain {
    func updateView(feed: Feed) {
        DispatchQueue.main.async {
            self.titleLabel.text = feed.title
        }
        self.setThumbnailImage(urlString: feed.thumbnailURL)
    }
}
