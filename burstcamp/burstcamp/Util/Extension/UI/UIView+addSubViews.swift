//
//  UIView+addSubViews.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

extension UIView {

    func addSubViews(_ subViews: [UIView]) {
        subViews.forEach { self.addSubview($0) }
    }
}
