//
//  LoadingView.swift
//  burstcamp
//
//  Created by youtak on 2022/12/13.
//

import UIKit

import SnapKit

final class LoadingView: UIView {

    private let logoImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "LaunchScreen")
        $0.contentMode = .scaleAspectFill
    }

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureView()
        configureImageView()
    }

    private func configureView() {
        backgroundColor = .background
    }

    private func configureImageView() {
        addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
    }
}
