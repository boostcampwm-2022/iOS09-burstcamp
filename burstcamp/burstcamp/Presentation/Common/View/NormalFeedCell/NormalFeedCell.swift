//
//  DefaultFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import Combine
import UIKit

import SnapKit

final class NormalFeedCell: UICollectionViewCell {

    private lazy var userInfoView = DefaultUserInfoView()
    private lazy var mainView = NormalFeedCellMain()
    lazy var footerView = NormalFeedCellFooter()

    private var scrapViewModel: ScrapViewModel!

    private var cancelBag = Set<AnyCancellable>()

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
        addSubViews([userInfoView, mainView, footerView])
        configureCell()
        configureHeaderStackView()
        configureMainStackView()
        configureFooterStackView()
    }

    private func configureCell() {
        backgroundColor = .clear
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

    func configure(with scrapViewModel: ScrapViewModel) {
        self.scrapViewModel = scrapViewModel
        bind()
    }

    private func bind() {
        let input = ScrapViewModel.Input(
            scrapToggleButtonDidTap: self.footerView.scrapButton.tapPublisher
        )

        let output = scrapViewModel.transform(input: input)

        output.scrapButtonState
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.isOn, on: footerView.scrapButton)
            .store(in: &cancelBag)

        output.scrapButtonIsEnabled
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.isEnabled, on: footerView.scrapButton)
            .store(in: &cancelBag)

        output.scrapButtonCount
            .receive(on: DispatchQueue.main)
            .map { "\($0)" }
            .weakAssign(to: \.text, on: footerView.countLabel)
            .store(in: &cancelBag)
    }
}

extension NormalFeedCell {
    func updateFeedCell(with feed: Feed) {
        userInfoView.updateView(feedWriter: feed.writer)
        mainView.updateView(feed: feed)
        footerView.updateView(feed: feed)
    }
}
