//
//  DomainViewController.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import UIKit

final class SignUpDomainViewController: UIViewController {

    private var signUpDomainView: SignUpDomainView {
        guard let view = view as? SignUpDomainView else { return SignUpDomainView() }
        return view
    }

    var coordinatorPublisher = PassthroughSubject<(AuthCoordinatorEvent, SignUpViewModel), Never>()
    let viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = SignUpDomainView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        signUpDomainView.webButton.addTarget(
            self,
            action: #selector(domainButtonDidTap(_:)),
            for: .touchUpInside
        )
        signUpDomainView.aosButton.addTarget(
            self,
            action: #selector(domainButtonDidTap(_:)),
            for: .touchUpInside
        )
        signUpDomainView.iosButton.addTarget(
            self,
            action: #selector(domainButtonDidTap(_:)),
            for: .touchUpInside
        )
    }

    @objc private func domainButtonDidTap(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        let buttons: [UIButton] = [
            signUpDomainView.webButton,
            signUpDomainView.aosButton,
            signUpDomainView.iosButton
        ]
        let domains: [Domain] = [Domain.web, Domain.android, Domain.iOS]

        zip(buttons, domains).forEach { button, domain in
            if title == domain.rawValue {
                button.backgroundColor = domain.color
                viewModel.domain = domain
            } else {
                button.backgroundColor = .systemGray5
            }
        }

        coordinatorPublisher.send((.moveToIDScreen, viewModel))
    }
}
