//
//  UIStackView+addArrangedSubviews.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ subViews: [UIView]) {
        subViews.forEach { self.addArrangedSubview($0) }
    }

    convenience init(
        views: [UIView],
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .equalSpacing,
        alignment: UIStackView.Alignment = .fill,
        spacing: Int
    ) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing.cgFloat
    }
}
