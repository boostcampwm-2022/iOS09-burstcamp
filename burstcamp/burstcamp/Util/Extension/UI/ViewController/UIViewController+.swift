//
//  UIViewController+ToastMessage.swift
//  burstcamp
//
//  Created by neuli on 2022/11/24.
//

import UIKit

import SnapKit
import Then

// MARK: - Interaction

extension UIViewController {
    func setUserInteraction(isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.view.isUserInteractionEnabled = isEnabled
    }
}

// MARK: Toast

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

            // https://github.com/realm/SwiftLint/issues/3581
            // swiftlint:disable:next multiline_arguments
            UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseOut]) {
                toastMessageLabel.alpha = 0.0
            } completion: { _ in
                toastMessageLabel.removeFromSuperview()
            }
        }
    }
}

// MARK: - Alert

extension UIViewController {
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
}

// MARK: - Indicator

// swiftlint:disable private_over_fileprivate
fileprivate let overlayViewTag: Int = 998
fileprivate let descriptionLabel: Int = 999
fileprivate let activityIndicatorViewTag: Int = 1000

extension UIViewController {
    private var overlayContainerView: UIView {
        if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }

    public func showAnimatedActivityIndicatorView(description: String = "") {
        guard !isShowingActivityIndicatorOverlay() else { return }

        let overlayView = createOverlayView()

        overlayContainerView.addSubview(overlayView)

        getActivityIndicatorView()?.startAnimating()
        getDescriptionLabel()?.text = description

        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func hideAnimatedActivityIndicatorView() {
        guard let overlayView = getOverlayView(),
              let activityIndicatorView = getActivityIndicatorView(),
              let descriptionLabel = getDescriptionLabel()
        else {
            return
        }

        // swiftlint:disable multiline_arguments
        UIView.animate(withDuration: 0.2) {
            overlayView.alpha = 0.0
            activityIndicatorView.stopAnimating()
        } completion: { _ in
            activityIndicatorView.removeFromSuperview()
            descriptionLabel.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
    }

    public func updateActivityOverlayDescriptionLabel(_ text: String) {
        getDescriptionLabel()?.text = text
    }

    private func createOverlayView() -> UIView {
        let overlayView = UIView().then {
            $0.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.3)
            $0.tag = overlayViewTag
        }

        let activityIndicatorView = createActivityIndicatorView()
        let descriptionLabel = createDescriptionLabel()

        overlayView.addSubViews([activityIndicatorView, descriptionLabel])

        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicatorView.snp.bottom).offset(Constant.space10)
        }

        return overlayView
    }

    private func createDescriptionLabel() -> UILabel {
        return UILabel().then {
            $0.font = .bold12
            $0.textColor = .dynamicBlack
            $0.tag = descriptionLabel
        }
    }

    private func createActivityIndicatorView() -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .medium).then {
            $0.tag = activityIndicatorViewTag
        }
    }

    private func isShowingActivityIndicatorOverlay() -> Bool {
        return getOverlayView() != nil && getActivityIndicatorView() != nil && getDescriptionLabel() != nil
    }

    private func getOverlayView() -> UIView? {
        return self.overlayContainerView.viewWithTag(overlayViewTag)
    }

    private func getActivityIndicatorView() -> UIActivityIndicatorView? {
        return self.overlayContainerView.viewWithTag(activityIndicatorViewTag) as? UIActivityIndicatorView
    }

    private func getDescriptionLabel() -> UILabel? {
        return self.overlayContainerView.viewWithTag(descriptionLabel) as? UILabel
    }
}
