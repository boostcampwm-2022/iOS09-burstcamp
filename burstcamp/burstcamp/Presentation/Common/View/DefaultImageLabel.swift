//
//  DefaultImageLabel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class DefaultImageLabel: UILabel {

    private let defaultIconBounds = CGRect(
        x: Constant.zero,
        y: Constant.spaceMinus2,
        width: Constant.space16,
        height: Constant.space12
    )

    private let defaultColor = UIColor.systemGray2
    private let defaultFont = UIFont.regular12

    init(
        icon: UIImage?,
        text: String,
        frame: CGRect = .zero,
        iconBounds: CGRect = CGRect(
            x: Constant.zero,
            y: Constant.spaceMinus2,
            width: Constant.space16,
            height: Constant.space12
        ),
        iconColor: UIColor = .systemGray2,
        font: UIFont = .regular12,
        textColor: UIColor = .systemGray2
    ) {
        super.init(frame: frame)
        attributedText = attributeString(
            icon: icon,
            iconColor: iconColor,
            iconBounds: iconBounds,
            text: text,
            font: font,
            textColor: textColor
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attributeString(
        icon: UIImage?,
        iconColor: UIColor,
        iconBounds: CGRect,
        text: String,
        font: UIFont = .regular12,
        textColor: UIColor
    ) -> NSAttributedString {
        let attributeString = NSMutableAttributedString()

        if let icon = icon {
            let imageAttributeString = imageAttributeString(
                icon: icon,
                iconColor: iconColor,
                iconBounds: iconBounds
            )
            attributeString.append(imageAttributeString)
            attributeString.append(NSAttributedString(string: " "))
        }

        let textAttributeString = textAttributeString(
            text: text,
            font: font,
            textColor: textColor
        )
        attributeString.append(textAttributeString)
        return attributeString
    }

    private func imageAttributeString(
        icon: UIImage?,
        iconColor: UIColor,
        iconBounds: CGRect
    ) -> NSAttributedString {
        let imageAttachment = NSTextAttachment().then {
            $0.image = icon?
                .withTintColor(iconColor, renderingMode: .alwaysOriginal)
            $0.bounds = iconBounds
        }
        return NSAttributedString(attachment: imageAttachment)
    }

    private func textAttributeString(
        text: String,
        font: UIFont,
        textColor: UIColor
    ) -> NSAttributedString {
        let textAttributeString = NSMutableAttributedString(
            string: text
        )
        textAttributeString.addAttribute(
            .font,
            value: font,
            range: NSRange(location: 0, length: text.count)
        )
        textAttributeString.addAttribute(
            .foregroundColor,
            value: textColor,
            range: NSRange(location: 0, length: text.count)
        )
        return textAttributeString
    }

    func updateBlogImageLabel(user: User) {
        let text = user.blogTitle.isEmpty ? "블로그를 등록해주세요." : user.blogTitle
        let attributeString = attributeString(
            icon: UIImage(systemName: "book.fill"),
            iconColor: defaultColor,
            iconBounds: defaultIconBounds,
            text: text,
            textColor: defaultColor
        )
        attributedText = attributeString
    }
}
