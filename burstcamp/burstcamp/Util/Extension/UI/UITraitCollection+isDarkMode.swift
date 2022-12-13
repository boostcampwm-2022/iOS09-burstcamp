//
//  UITraitCollection+isDarkMode.swift
//  burstcamp
//
//  Created by youtak on 2022/12/13.
//

import UIKit.UITraitCollection

extension UITraitCollection {
    var isDarkMode: Bool {
        return self.userInterfaceStyle == .dark ? true : false
    }
}
