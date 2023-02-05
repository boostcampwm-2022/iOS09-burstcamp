//
//  UILabel+LineHeight.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

extension UILabel {
    func setLineHeight160() {
        guard let labelText = self.text else { return }
        let fontSize = self.font.pointSize
        let lineHeight = fontSize * 1.6

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight

        let baseLineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: baseLineOffset
        ]

        self.attributedText = NSAttributedString(string: labelText, attributes: attributes)
    }
}

// baslineOffset 참고
//https://sujinnaljin.medium.com/swift-label%EC%9D%98-line-height-%EC%84%A4%EC%A0%95-%EB%B0%8F-%EA%B0%80%EC%9A%B4%EB%8D%B0-%EC%A0%95%EB%A0%AC-962f7c6e7512
//http://blog.eppz.eu/uilabel-line-height-letter-spacing-and-more-uilabel-typography-extensions/
