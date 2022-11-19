//
//  RecommendFeedCell.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import UIKit

final class RecommendFeedCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        configureCell()
    }

    private func configureCell() {
        backgroundColor = .orange
    }
}
