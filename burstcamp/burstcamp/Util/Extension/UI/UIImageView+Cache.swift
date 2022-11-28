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
            .sink { completion in
                if case .failure = completion {
                    print("Image Cache Error: \(completion)")
                } else {
                    print("Image Cache Finish")
                }
            } receiveValue: { image in
                self.image = image
            }
            .store(in: &ImageCacheManager.shared.cancelBag)
    }
}
