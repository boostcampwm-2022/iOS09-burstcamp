//
//  DefaultToggleButton.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/11/29.
//

import Combine
import UIKit

final class ToggleButton: UIButton {
    private let onImage: UIImage?
    private let offImage: UIImage?

    private(set) var isOn: Bool = false {
        didSet {
            configure()
        }
    }

    init(
        onImage: UIImage?,
        onColor: UIColor,
        offImage: UIImage?,
        offColor: UIColor
    ) {
        self.onImage = onImage?.withTintColor(onColor, renderingMode: .alwaysOriginal)
        self.offImage = offImage?.withTintColor(offColor, renderingMode: .alwaysOriginal)
        super.init(frame: .zero)
        configure()
    }

    convenience init(
        image: UIImage?,
        onColor: UIColor,
        offColor: UIColor
    ) {
        self.init(
            onImage: image,
            onColor: onColor,
            offImage: image,
            offColor: offColor
        )
    }

    convenience init(
        onImage: UIImage?,
        offImage: UIImage?
    ) {
        self.init(
            onImage: onImage,
            onColor: .systemBlue,
            offImage: offImage,
            offColor: .systemBlue
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        let image = isOn ? onImage : offImage
        setImage(image, for: .normal)
    }
}

// MARK: Interface

extension ToggleButton {
    var statePublisher: AnyPublisher<Bool, Never> {
        controlPublisher(for: .touchUpInside)
            .compactMap { $0 as? ToggleButton }
            .map { $0.isOn }
            .eraseToAnyPublisher()
    }

    func toggle() {
        isOn.toggle()
    }

    func updateView(with state: Bool) {
        isOn = state
    }
}
