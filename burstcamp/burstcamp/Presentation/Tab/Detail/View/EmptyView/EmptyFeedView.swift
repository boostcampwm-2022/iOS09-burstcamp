//
//  EmptyFeedView.swift
//  burstcamp
//
//  Created by youtak on 2023/01/28.
//

import UIKit

final class EmptyFeedView: UIView {

    private let imageView = UIImageView().then {
        $0.image = UIImage.burstcamperStun
    }

    private let descriptionLabel =  DefaultMultiLineLabel().then {
        $0.text = "컨텐츠 내용을 불러오는데 오류가 발생했어요\n블로그에서 내용을 확인해주세요!"
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
        addSubViews([imageView, descriptionLabel])
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
