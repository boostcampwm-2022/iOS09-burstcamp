//
//  UICollectionView+emptyView.swift
//  burstcamp
//
//  Created by youtak on 2022/12/02.
//

import UIKit

import SnapKit

extension UICollectionView {

    func configureEmptyView() {
        let emptyView = UIView().then {
            $0.frame = CGRect(
                x: self.center.x,
                y: self.center.y,
                width: self.bounds.width,
                height: self.bounds.height
            )
        }

        let imageView = UIImageView().then {
            $0.image = UIImage(named: "AppIcon")
        }

        let descriptionLabel = UILabel().then {
            $0.text = "아직 스크랩한 피드가 없어요"
            $0.font = .regular14
            $0.textColor = .systemGray2
        }

        emptyView.addSubViews([imageView, descriptionLabel])

        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(Constant.Image.profileMedium)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }

        self.backgroundView = emptyView
    }

    func resetEmptyView() {
        self.backgroundView = nil
    }
}
