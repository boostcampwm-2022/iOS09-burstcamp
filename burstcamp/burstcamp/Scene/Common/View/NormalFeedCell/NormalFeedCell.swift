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

    private var feedScrapViewModel: FeedScrapViewModel!

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

    func configure(with feedScrapViewModel: FeedScrapViewModel) {
        self.feedScrapViewModel = feedScrapViewModel
        bind()
    }

    private func bind() {
        let scrapButton = footerView.scrapButton

        let input = FeedScrapViewModel.Input(
            viewDidLoad: Just(Void()).eraseToAnyPublisher(),
            scrapToggleButtonDidTap: scrapButton.statePublisher
        )

        let output = feedScrapViewModel.transform(input: input)

        output.scrapToggleButtonState
            .receive(on: DispatchQueue.main)
            .sink { state in
                scrapButton.updateView(with: state)
            }
            .store(in: &cancelBag)

        output.scrapToggleButtonIsEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: scrapButton)
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
