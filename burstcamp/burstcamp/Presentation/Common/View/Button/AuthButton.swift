//
//  AuthButton.swift
//  burstcamp
//
//  Created by youtak on 2023/01/30.
//

import UIKit

enum AuthButtonKind {
    case apple
    case github
}

final class AuthButton: UIButton {

    init(
        kind: AuthButtonKind
    ) {
        super.init(frame: .zero)

        let text = getText(kind: kind)
        var string = AttributedString(text)
        string.font = UIFont.extraBold14
        string.foregroundColor = .dynamicWhite

        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = string
        configuration.titleAlignment = .center

        configuration.image = getImage(kind: kind)
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

    private func getText(kind: AuthButtonKind) -> String {
        switch kind {
        case .apple: return "Apple로 로그인"
        case .github: return "Github으로 로그인"
        }
    }

    private func getImage(kind: AuthButtonKind) -> UIImage? {
        switch kind {
        case .apple:
            guard #available(iOS 16, *) else {
                return UIImage(systemName: "applelogo")?.withTintColor(UIColor.dynamicWhite, renderingMode: .alwaysOriginal)
            }
            return UIImage(systemName: "apple.logo")?.withTintColor(UIColor.dynamicWhite, renderingMode: .alwaysOriginal)
        case .github:
            return .github
        }
    }
}
