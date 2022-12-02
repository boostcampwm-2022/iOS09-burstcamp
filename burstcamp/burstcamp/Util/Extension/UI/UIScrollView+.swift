//
//  UIScrollView+.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import UIKit

extension UIScrollView {

    func isOverTarget(ratio: CGFloat = 0.8) -> Bool {
        let offset = contentOffset.y
        let targetOffset = (contentSize.height - frame.height) * ratio
        return offset > targetOffset
    }
}
