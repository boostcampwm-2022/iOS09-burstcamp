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

    var coordinatorPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()
    private var cancelBag = Set<AnyCancellable>()

    private let viewModel: SignUpDomainViewModel

    init(viewModel: SignUpDomainViewModel) {
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
        let input = SignUpDomainViewModel.Input(
            webButtonTouchDown: signUpDomainView.webButton.touchDownPublisher,
            aosButtonTouchDown: signUpDomainView.aosButton.touchDownPublisher,
            iosButtonTouchDown: signUpDomainView.iosButton.touchDownPublisher,
            webButtonDidTap: signUpDomainView.webButton.tapPublisher,
            aosButtonDidTap: signUpDomainView.aosButton.tapPublisher,
            iosButtonDidTap: signUpDomainView.iosButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.webButtonChangeColor
            .sink { domain in
                self.changeUI(domain: domain)
            }
            .store(in: &cancelBag)

        output.aosButtonChangeColor
            .sink { domain in
                self.changeUI(domain: domain)
            }
            .store(in: &cancelBag)

        output.iosButtonChangeColor
            .sink { domain in
                self.changeUI(domain: domain)
            }
            .store(in: &cancelBag)

        output.webSelected
            .sink { _ in
                self.coordinatorPublisher.send(.moveToIDScreen)
            }
            .store(in: &cancelBag)

        output.aosSelected
            .sink { _ in
                self.coordinatorPublisher.send(.moveToIDScreen)
            }
            .store(in: &cancelBag)

        output.iosSelected
            .sink { _ in
                self.coordinatorPublisher.send(.moveToIDScreen)
            }
            .store(in: &cancelBag)
    }

    private func changeUI(domain: Domain) {
        [
            signUpDomainView.webButton,
            signUpDomainView.aosButton,
            signUpDomainView.iosButton
        ]
            .forEach { button in
                if button.currentTitle == domain.rawValue {
                    button.backgroundColor = domain.color
                } else {
                    button.backgroundColor = .systemGray5
                }
            }
    }
}
