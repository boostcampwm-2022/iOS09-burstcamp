//
//  LoadingFeedView.swift
//  burstcamp
//
//  Created by youtak on 2023/02/02.
//

import UIKit

import SwiftyGif

final class LoadingFeedView: UIView {

    private let imageView = UIImageView()

    private let descriptionLabel =  DefaultMultiLineLabel().then {
        $0.text = "로딩 중이에요"
        $0.font = .bold14
        $0.textColor = .systemGray2
        $0.numberOfLines = 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureImageView()
        addSubViews([imageView, descriptionLabel])
    }

    private func configureImageView() {
        do {
            let gifImage = try UIImage(gifName: "burstcamp_loading.gif")
            let imageView = UIImageView(gifImage: gifImage, loopCount: -1)
        } catch {
            debugPrint("gif 설정 실패")
            imageView.image = UIImage.burstcamper
        }
    }

    private func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(Constant.Image.profileMedium)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(Constant.space8)
        }
    }
}
