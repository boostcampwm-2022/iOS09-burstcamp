//
//  AppDelegate.swift
//  burstcamp
//
//  Created by youtak on 2022/12/08.
//

import UIKit

extension UIViewController {
    override func handleError(
        _ error: Error,
        from viewController: UIViewController,
        retryHandler: @escaping () -> Void = {}
    ) {
        let alert = UIAlertController(
            title: "에러가 발생했습니다",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(
            title: "취소",
            style: .default)
        )

        switch error.resolveCategory() {
        case .retryable:
            let alertAction = UIAlertAction(
                title: "재시도",
                style: .default) { _ in
                    retryHandler()
                }
            alert.addAction(alertAction)
        case .nonRetryable:
            break
        }

        viewController.present(alert, animated: true)
    }
}
