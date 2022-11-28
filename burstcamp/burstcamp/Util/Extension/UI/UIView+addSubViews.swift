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

    func paddingView() -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    }
}
