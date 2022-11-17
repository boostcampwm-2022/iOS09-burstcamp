//
//  DefaultFeedCellBadgeStackView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

class DefaultFeedCellBadgeStackView: UIStackView {

    lazy var domainLabel = UILabel().then {
        $0.textColor = UIColor.customOrange
        $0.font = UIFont.bold10
        $0.text = "iOS"
    }

    lazy var numberLabel = UILabel().then {
        $0.textColor = UIColor.customBlue
        $0.font = UIFont.bold12
        $0.text = "7기"
    }

    lazy var camperIDLabel = UILabel().then {
        $0.textColor = UIColor.systemGray2
        $0.font = UIFont.bold12
        $0.text = "S057"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureStackView()
        configureSubViews()
    }

    private func configureStackView() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
        spacing = 4
    }

    private func configureSubViews() {
        addArrangedSubViews([domainLabel, numberLabel, camperIDLabel])
    }
}
