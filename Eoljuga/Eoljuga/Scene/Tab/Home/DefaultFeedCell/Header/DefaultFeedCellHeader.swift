//
//  DefaultFeedCellHeader.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

class DefaultFeedCellHeader: UIStackView {

    lazy var profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.image = UIImage(systemName: "person")
    }

    lazy var nameLabel = UILabel().then {
        $0.textColor = UIColor.systemGray
        $0.font = UIFont.bold12
        $0.text = "하늘이"
    }

    lazy var badgeStackView = DefaultFeedCellBadgeStackView()

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
        spacing = 8
    }

    private func configureSubViews() {
        addArrangedSubViews([profileImageView, nameLabel, badgeStackView])
    }
}
