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
    private var cancelBag = Set<AnyCancellable>()

    private let viewModel: SignUpViewModel

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
        let domainSubject = PassthroughSubject<Domain, Never>()

        domainButtons.forEach { button in
            guard let title = button.currentTitle,
                  let domain = Domain(rawValue: title)
            else {
                return
            }

            button.tapPublisher
                .sink { _ in
                    domainSubject.send(domain)
                    self.coordinatorPublisher.send((.moveToIDScreen, self.viewModel))
                }
                .store(in: &cancelBag)

            button.touchDownPublisher
                .sink { _ in
                    self.domainButtons.forEach { $0.backgroundColor = .systemGray5 }
                    button.backgroundColor = domain.color
                }
                .store(in: &cancelBag)
        }

        let input = SignUpViewModel.InputDomain(
            domainButtonDidTap: domainSubject
        )

        viewModel.transformDomain(input: input)
    }
}
