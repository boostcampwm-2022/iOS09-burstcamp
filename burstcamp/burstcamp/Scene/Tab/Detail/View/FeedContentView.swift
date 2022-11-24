//
//  FeedContentView.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/11/24.
//

import UIKit

final class FeedContentView: UITextView {
    override var attributedText: NSAttributedString! {
        didSet {
            configureTextStyle()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
        configureTextStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextView() {
        isEditable = false
        backgroundColor = nil
    }

    private func configureTextStyle() {
        font = .regular14
        textColor = .dynamicBlack
    }

    func fetchContentFromHTML(_ htmlString: String) {
        NSAttributedString.loadFromHTML(string: htmlString) { attributedString, _, _ in
            self.attributedText = attributedString
        }
    }
}
