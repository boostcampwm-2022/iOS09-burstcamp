//
//  MyPageEditView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class MyPageEditView: UIView {

    // MARK: - Properties

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func configureUI() {
        backgroundColor = .background
    }
}
