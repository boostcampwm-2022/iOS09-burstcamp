//
//  UILabel+LineHeight.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

extension UILabel {
    func lineHeight160() {
        guard let labelText = self.text else { return }
        let fontSize = self.font.pointSize
        let lineHeight = fontSize * 1.6

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style
        ]

        self.attributedText = NSAttributedString(string: labelText, attributes: attributes)
    }
}
