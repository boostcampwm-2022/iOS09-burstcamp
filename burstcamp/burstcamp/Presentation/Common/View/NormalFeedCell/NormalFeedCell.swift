//
//  DefaultFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import Combine
import UIKit

import SkeletonView
import SnapKit

final class NormalFeedCell: UICollectionViewCell {

    private lazy var userInfoView = DefaultUserInfoView().then {
        $0.isSkeletonable = true
    }
    private lazy var mainView = NormalFeedCellMain().then {
        $0.isSkeletonable = true
    }
    lazy var footerView = NormalFeedCellFooter()

    var cancelBag = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userInfoView.reset()
        cancelBag = Set<AnyCancellable>()
    }

    private func configureUI() {
        contentView.addSubViews([userInfoView, mainView, footerView])
        configureCell()
        configureSkeletonView()
        configureHeaderStackView()
        configureMainStackView()
        configureFooterStackView()
    }

    private func configureCell() {
        backgroundColor = .clear
    }

    private func configureSkeletonView() {
        isSkeletonable = true
    }

    private func configureHeaderStackView() {
        userInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constant.Cell.normalTopMargin)
            $0.leading.equalToSuperview()
            $0.height.equalTo(Constant.Cell.normalHeaderHeight)
        }
    }

    private func configureMainStackView() {
        mainView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constant.Cell.normalMainHeight)
        }
    }

    private func configureFooterStackView() {
        footerView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constant.Cell.normalFooterHeight)
        }
    }
}

extension NormalFeedCell {
    func updateFeedCell(with feed: Feed) {
        userInfoView.updateView(feedWriter: feed.writer)
        mainView.updateView(feed: feed)
        footerView.updateView(feed: feed)
    }

    func getButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return footerView.scrapButton.tapPublisher
    }
}
