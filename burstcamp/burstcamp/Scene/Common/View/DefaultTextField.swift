//
//  DefaultTextField.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class DefaultTextField: UITextField {

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= Constant.space16.cgFloat
        return padding
    }

    init(
        placeholder: String
    ) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = Constant.CornerRadius.radius8.cgFloat
        font = .regular16
        clearButtonMode = .whileEditing
        addLeftPadding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(
            x: Constant.zero,
            y: Constant.zero,
            width: Constant.space16,
            height: Int(frame.height)
        ))
        leftView = paddingView
        leftViewMode = .always
    }
}
