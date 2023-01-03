//
//  OpenSourceLicenseViewController.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import UIKit

final class OpenSourceLicenseViewController: UIViewController {

    // MARK: - Properties

    private var openSourceLicenseView: OpenSourceLicenseView {
        guard let view = view as? OpenSourceLicenseView else {
            return OpenSourceLicenseView()
        }
        return view
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = OpenSourceLicenseView()
    }

    override func viewDidLoad() {
    }

    // MARK: - Methods
}
