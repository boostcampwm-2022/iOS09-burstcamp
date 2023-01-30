//
//  AuthButton.swift
//  burstcamp
//
//  Created by youtak on 2023/01/30.
//

import UIKit

final class AuthButton: UIButton {

    init(
        text: String,
        image: UIImage?
    ) {
        super.init(frame: .zero)

        var string = AttributedString(text)
        string.font = UIFont.extraBold14
        string.foregroundColor = .dynamicWhite

        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = string
        configuration.titleAlignment = .center

        configuration.image = image
        configuration.imagePlacement = .leading
        configuration.imagePadding = 20

        configuration.baseBackgroundColor = .dynamicBlack
        configuration.cornerStyle = .medium

        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)

        self.configuration = configuration
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
