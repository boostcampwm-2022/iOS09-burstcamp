//
//  DefaultFeedCellFooter.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

class DefaultFeedCellFooter: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
    }
}
