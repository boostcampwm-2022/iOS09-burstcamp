//
//  UIImageView+Cache.swift
//  burstcamp
//
//  Created by neuli on 2022/11/27.
//

import Combine
import UIKit

extension UIImageView {

    func setImage(urlString: String,
                  isDiskCaching: Bool = false,
                  defaultImage: UIImage? = UIImage(named: "burstcamper100")
    ) {
        ImageCacheManager.shared.image(urlString: urlString, isDiskCaching: isDiskCaching)
            .map { image in image == nil ? defaultImage : image }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &ImageCacheManager.shared.cancelBag)
    }
}
