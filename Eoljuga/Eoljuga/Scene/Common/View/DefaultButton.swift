//
//  DefaultButton.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class DefaultButton: UIButton {

    init(
        title: String,
        font: UIFont = .extraBold16
    ) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .main
        titleLabel?.font = font
        layer.cornerRadius = Constant.CornerRadius.radius8.cgFloat
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
