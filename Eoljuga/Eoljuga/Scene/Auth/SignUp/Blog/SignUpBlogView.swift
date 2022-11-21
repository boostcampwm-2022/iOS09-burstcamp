//
//  SignUpBlogView.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/20.
//

import UIKit

import SnapKit
import Then

final class SignUpBlogView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        backgroundColor = .systemBackground
    }
}
