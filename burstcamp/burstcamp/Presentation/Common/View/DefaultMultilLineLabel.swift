//
//  DefaultMultilLineLabel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/11/23.
//

import UIKit

class DefaultMultiLineLabel: UILabel {
    override var text: String? {
        didSet {
            setLineHeight160()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMultiLineSetting()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureMultiLineSetting() {
        lineBreakMode = .byWordWrapping
        lineBreakStrategy = .hangulWordPriority
    }
}
