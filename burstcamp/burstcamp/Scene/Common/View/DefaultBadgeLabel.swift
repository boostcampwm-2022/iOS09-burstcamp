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
        top: Constant.space2.cgFloat,
        left: Constant.space8.cgFloat,
        bottom: Constant.space2.cgFloat,
        right: Constant.space8.cgFloat
    )

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    // MARK: - Initializer

    init(
        textColor: UIColor,
        text: String = ""
    ) {
        super.init(frame: .zero)
        font = UIFont.bold10
        self.text = text
        self.textColor = textColor
        backgroundColor = .systemGray5
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

extension DefaultBadgeLabel {
    func updateView(text: String) {
        DispatchQueue.main.async {
            self.text = text
        }
    }
}
