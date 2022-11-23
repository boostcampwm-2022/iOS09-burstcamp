//
//  ReusableView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import Foundation

protocol ReusableView {
    static var identifier: String { get }
}

extension ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
