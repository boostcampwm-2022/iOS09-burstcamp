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

    private var domainButtons: [UIButton] {
        return [
            signUpDomainView.webButton,
            signUpDomainView.aosButton,
            signUpDomainView.iosButton
        ]
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
        [signUpDomainView.webButton, signUpDomainView.aosButton, signUpDomainView.iosButton]
            .forEach { button in
                button.addTarget(
                    self,
                    action: #selector(domainButtonStartTouch(_:)),
                    for: .touchDown
                )

                button.addTarget(
                    self,
                    action: #selector(domainButtonDidTouch(_:)),
                    for: .touchUpInside
                )

                button.addTarget(
                    self,
                    action: #selector(domainButtonTouchUpOutside(_:)),
                    for: .touchUpOutside
                )
            }
    }

    @objc private func domainButtonStartTouch(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        let domains: [Domain] = [Domain.web, Domain.android, Domain.iOS]

        zip(domainButtons, domains).forEach { button, domain in
            if title == domain.rawValue {
                button.backgroundColor = domain.color
                viewModel.domain = domain
            } else {
                button.backgroundColor = .systemGray5
            }
        }
    }

    @objc private func domainButtonDidTouch(_ sender: UIButton) {
        coordinatorPublisher.send((.moveToIDScreen, viewModel))
    }

    @objc private func domainButtonTouchUpOutside(_ sender: UIButton) {
        domainButtons.forEach { button in
            button.backgroundColor = .systemGray5
        }
    }
}
