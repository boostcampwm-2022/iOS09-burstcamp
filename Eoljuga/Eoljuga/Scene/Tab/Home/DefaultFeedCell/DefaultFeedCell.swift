//
//  DefaultFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import UIKit

final class DefaultFeedCell: UICollectionViewCell {

    lazy var headerStackView = DefaultFeedCellHeader()
    lazy var mainStackView = DefaultFeedCellMain()
    lazy var footerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        configureHeaderStackView()
        configureMainStackView()
        configureFooterStackView()
    }

    private func configureHeaderStackView() {
        addSubview(headerStackView)
        headerStackView.backgroundColor = .systemBlue
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    private func configureMainStackView() {
        addSubview(mainStackView)
        mainStackView.backgroundColor = .systemRed
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(75)
        }
    }

    private func configureFooterStackView() {
        addSubview(footerStackView)
        footerStackView.backgroundColor = .systemGreen
        footerStackView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
}
