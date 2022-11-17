//
//  UIViewController+.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

extension UIViewController {
    func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = false
    }

    func showNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
}
