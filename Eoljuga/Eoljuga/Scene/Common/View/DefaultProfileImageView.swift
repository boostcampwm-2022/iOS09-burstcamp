//
//  DefaultProfileImageView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class DefaultProfileImageView: UIImageView {

    init(imageSize: Int) {
        super.init(frame: .zero)
        layer.cornerRadius = imageSize.cgFloat / 2
        clipsToBounds = true
        layer.masksToBounds = true
        image = UIImage(systemName: "square.fill")
        contentMode = .scaleAspectFill
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
