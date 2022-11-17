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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureStackView()
        configureProfileImageView()
    }

    private func configureStackView() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
    }

    private func configureProfileImageView() {
        addArrangedSubview(profileImageView)
    }
}
