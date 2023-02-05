//
//  FeedDetailWebView.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/11/24.
//

import UIKit
import WebKit

final class FeedContentWebView: WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        isOpaque = false
        tintColor = .dynamicWhite
        allowsLinkPreview = false
        scrollView.contentInset = .zero
        scrollView.isScrollEnabled = false
        scrollView.layer.masksToBounds = false
        scrollView.bounces = false
    }

    private var meta: String {
        // swiftlint:disable:next line_length
        return #"<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=0"/>"#
    }

    private var style: String {
        return """
               <style>
               :root {
                 color-scheme: light dark;
                 overflow-wrap: break-word;
               }
               img {
                 width: auto;
                 height: auto;
                 max-width: 100%;
               }
               body {
                   font-family: 'NanumSquare', -apple-system;
                   font-size: 14px;
               }
               code {
                 display: block;
                 white-space: pre-line;
                 font-size: 11px;
               }
               * {
                 -webkit-touch-callout: none;
               }
               </style>
               """
    }
}

// 외부에서 사용하는 메서드 및 프로퍼티
extension FeedContentWebView {
    func loadFormattedHTMLString(_ string: String) {
        let formattedHTMLString = """
        <html>
          <head>
            \(meta)
            \(style)
          </head>
          <body>
            \(string)
          </body>
        </html>
        """
        loadHTMLString(formattedHTMLString, baseURL: nil)
    }
}
