//
//  DefaultBadgeLabel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class DefaultBadgeLabel: UILabel {

    // MARK: - Properties

    private let padding = UIEdgeInsets(
        top: Constant.Padding.padding2.cgFloat,
        left: Constant.Padding.padding8.cgFloat,
        bottom: Constant.Padding.padding2.cgFloat,
        right: Constant.Padding.padding8.cgFloat
    )

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    // MARK: - Initializer

    init(
        text: String,
        textColor: UIColor
    ) {
        super.init(frame: .zero)
        font = UIFont.bold10
        self.text = text
        self.textColor = textColor
        backgroundColor = .systemGray6
        layer.cornerRadius = Constant.CornerRadius.radius8.cgFloat
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}