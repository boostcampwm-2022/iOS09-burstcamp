//
//  DefaultFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import UIKit

import SnapKit

final class DefaultFeedCell: UICollectionViewCell {

    lazy var headerStackView = DefaultFeedCellHeader()
    lazy var mainStackView = DefaultFeedCellMain()
    lazy var footerStackView = DefaultFeedCellFooter()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        configureCell()
        configureHeaderStackView()
        configureMainStackView()
        configureFooterStackView()
    }

    private func configureCell() {
        backgroundColor = .clear
    }

    private func configureHeaderStackView() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constant.Cell.topMargin)
            $0.leading.equalToSuperview()
            $0.height.equalTo(Constant.Cell.headerHeight)
        }
    }

    private func configureMainStackView() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constant.Cell.mainHeight)
        }
    }

    private func configureFooterStackView() {
        addSubview(footerStackView)
        footerStackView.backgroundColor = .systemGreen
        footerStackView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constant.Cell.footerHeight)
        }
    }
}
