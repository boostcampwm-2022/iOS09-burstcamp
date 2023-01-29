//
//  DefaultProfileImageView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class DefaultProfileImageView: UIImageView {

    let imageSize: Int

    init(imageSize: Int) {
        self.imageSize = imageSize
        super.init(frame: .zero)
        layer.cornerRadius = imageSize.cgFloat / 2
        clipsToBounds = true
        image = UIImage(systemName: "person.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        contentMode = .scaleAspectFill
        backgroundColor = .systemGray2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
