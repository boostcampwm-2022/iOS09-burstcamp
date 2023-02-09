//
//  RecommendFeedHeader.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/20.
//

import UIKit

final class RecommendFeedHeader: UICollectionReusableView {

    private let titleText = "이번 주\n캠퍼들의 PICK"

    private lazy var titleAttributeText = NSMutableAttributedString(string: titleText).then {
        let string = titleText as NSString
        let length = string.length
        $0.addAttribute(
            .font, value: UIFont.extraBold24, range: NSRange(location: 0, length: length)
        )
        $0.addAttribute(.foregroundColor, value: UIColor.main, range: string.range(of: "이"))
        $0.addAttribute(.foregroundColor, value: UIColor.main, range: string.range(of: "P"))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        $0.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: length)
        )
    }

    private lazy var titleLabel = DefaultMultiLineLabel().then {
        $0.numberOfLines = 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(titleLabel)
        configureTitleLabel()
    }

    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension RecommendFeedHeader {
    func updateTitleLabel() {
        DispatchQueue.main.async {
            self.titleLabel.attributedText = self.titleAttributeText
        }
    }
}
