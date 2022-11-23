//
//  DefaultImageLabel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class DefaultImageLabel: UILabel {

    private let fontAttribute: [NSAttributedString.Key: Any] = [
        .font: UIFont.regular12
    ]

    private let colorAttribute: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.systemGray2
    ]

    private lazy var attributes: [NSAttributedString.Key: Any] = fontAttribute
        .merging(colorAttribute) { _, new in new }

    init(
        icon: UIImage?,
        text: String
    ) {
        super.init(frame: .zero)
        attributedText = attributeString(icon: icon, text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attributeString(icon: UIImage?, text: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString()

        if let icon = icon {
            let imageAttributeString = imageAttributeString(icon: icon)
            attributeString.append(imageAttributeString)
            attributeString.append(NSAttributedString(string: " "))
        }

        let textAttributeString = textAttributeString(text: text)
        attributeString.append(textAttributeString)
        return attributeString
    }

    private func imageAttributeString(icon: UIImage?) -> NSAttributedString {
        let imageAttachment = NSTextAttachment().then {
            $0.image = icon?
                .withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
            $0.bounds = CGRect(
                x: Constant.zero,
                y: Constant.spaceMinus2,
                width: Constant.space16,
                height: Constant.space12
            )
        }
        return NSAttributedString(attachment: imageAttachment)
    }

    private func textAttributeString(text: String) -> NSAttributedString {
        let textAttributeString = NSMutableAttributedString(
            string: text
        )
        textAttributeString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: text.count)
        )
        return textAttributeString
    }
}
