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
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = backgroundColor
//            navigationBar.standardAppearance = navigationBarAppearance
//            navigationBar.scrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        }
    }
}
