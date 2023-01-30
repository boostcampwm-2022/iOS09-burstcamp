//
//  UIViewController+ToastMessage.swift
//  burstcamp
//
//  Created by neuli on 2022/11/24.
//

import UIKit

extension UIViewController {

    var toastFrame: CGRect {
        CGRect(
            x: Constant.space16,
            y: Int(view.frame.size.height) - Constant.space100,
            width: Int(view.frame.size.width) - Constant.space32,
            height: Constant.space48
        )
    }

    var toastIconBounds: CGRect {
        CGRect(
            x: Constant.zero,
            y: Constant.zero,
            width: Constant.space16,
            height: Constant.space16
        )
    }

    func showToastMessage(
        text: String,
        icon: UIImage? = UIImage(systemName: "eyes.inverse")
    ) {
        let toastMessageLabel = DefaultImageLabel(
            icon: icon,
            text: " \(text)",
            frame: toastFrame,
            iconBounds: toastIconBounds,
            iconColor: .white,
            font: .extraBold16,
            textColor: .white
        )
        toastMessageLabel.textAlignment = .center
        toastMessageLabel.alpha = 1.0
        toastMessageLabel.backgroundColor = .systemGray2
        toastMessageLabel.layer.cornerRadius = Constant.CornerRadius.radius8.cgFloat
        toastMessageLabel.clipsToBounds = true

        DispatchQueue.main.async {
            self.view.addSubview(toastMessageLabel)
        }

        // https://github.com/realm/SwiftLint/issues/3581
        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseOut]) {
            toastMessageLabel.alpha = 0.0
        } completion: { _ in
            toastMessageLabel.removeFromSuperview()
        }
    }

    func showAlert(title: String = "", message: String, alertActions: [UIAlertAction] = []) {
        let sheet = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        if alertActions.isEmpty {
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            sheet.addAction(confirmAction)
        } else {
            alertActions.forEach { alertAction in
                sheet.addAction(alertAction)
            }
        }

        DispatchQueue.main.async {
            self.present(sheet, animated: true)
        }
    }

    func setUserInteraction(isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.view.isUserInteractionEnabled = isEnabled
    }
}
