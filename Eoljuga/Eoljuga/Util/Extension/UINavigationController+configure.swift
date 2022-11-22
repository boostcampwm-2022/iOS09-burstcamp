//
//  UINavigationController+configure.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import UIKit

extension UINavigationController {

    convenience init(backgroundColor: UIColor = .background) {
        self.init()
        self.navigationBar.backgroundColor = backgroundColor
    }
}
