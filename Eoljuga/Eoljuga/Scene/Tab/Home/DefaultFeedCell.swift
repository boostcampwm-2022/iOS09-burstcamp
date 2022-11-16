//
//  DefaultFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import UIKit

final class DefaultFeedCell: UICollectionViewCell {

    static let identifier = "defaultFeedCell"

    lazy var headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }

    override func layoutSubviews() {
        configure()
    }

    private func configure() {
        configureHeaderStackView()
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
}
