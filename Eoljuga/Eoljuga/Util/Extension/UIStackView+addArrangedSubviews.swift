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
}
