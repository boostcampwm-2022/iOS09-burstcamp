//
//  RecommendFeedHeader.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/20.
//

import UIKit

final class RecommendFeedHeader: UICollectionReusableView {

    private lazy var titleLabel = UILabel().then {
        $0.textColor = .dynamicBlack
        $0.font = .extraBold24
        $0.text = "이번 주의\n새로운 글들이에요"
        $0.numberOfLines = 2
        $0.setLineHeight160()
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
