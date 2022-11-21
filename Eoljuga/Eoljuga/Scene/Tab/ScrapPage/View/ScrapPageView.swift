//
//  ScrapView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import UIKit

class ScrapPageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .white
    }
}
