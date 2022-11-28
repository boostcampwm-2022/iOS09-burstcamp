//
//  UIImageView+Cache.swift
//  burstcamp
//
//  Created by neuli on 2022/11/27.
//

import Combine
import UIKit

extension UIImageView {

    func setImage(urlString: String, isDiskCaching: Bool = false) {
        ImageCacheManager.shared.image(urlString: urlString, isDiskCaching: isDiskCaching)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &ImageCacheManager.shared.cancelBag)
    }
}
