//
//  UITextField+Padding.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/11/28.
//

import UIKit

extension UITextField {
    func addHorizontalPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
