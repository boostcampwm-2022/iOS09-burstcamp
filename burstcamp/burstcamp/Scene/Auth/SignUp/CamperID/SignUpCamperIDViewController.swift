//
//  CamperIDViewController.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import UIKit

final class SignUpCamperIDViewController: UIViewController {

    private var signUpCamperIDView: SignUpCamperIDView {
        guard let view = view as? SignUpCamperIDView else { return SignUpCamperIDView() }
        return view
    }

    var coordinatorPublisher = PassthroughSubject<(AuthCoordinatorEvent, SignUpViewModel), Never>()
    private var cancelBag = Set<AnyCancellable>()

    private let viewModel: SignUpViewModel
    private let idTextFieldMaxCount = 3

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SignUpCamperIDView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        configureUIByDomain()
        bind()
    }

    private func setDelegate() {
        signUpCamperIDView.idTextField.delegate = self
    }

    private func configureUIByDomain() {
        signUpCamperIDView.domainLabel.text = viewModel.domain.rawValue
        signUpCamperIDView.representingDomainLabel.text = viewModel.domain.representingDomain
    }

    private func bind() {
        signUpCamperIDView.nextButton.tapPublisher
            .sink {
                self.coordinatorPublisher.send((.moveToBlogScreen, self.viewModel))
            }
            .store(in: &cancelBag)

        let textPublisher = signUpCamperIDView.idTextField.textPublisher

        let input = SignUpViewModel.InputCamperID(
            camperIDTextFieldDidEdit: textPublisher
        )

        viewModel.transformCamperID(input: input)
            .validateCamperID
            .sink { validate in
                self.signUpCamperIDView.nextButton.isEnabled = validate
                self.signUpCamperIDView.nextButton.alpha = validate ? 1.0 : 0.3
            }
            .store(in: &cancelBag)
    }
}

extension SignUpCamperIDViewController: UITextFieldDelegate {
    private func idLengthValidate(text: String, range: NSRange) -> Bool {
        return !(text.count >= idTextFieldMaxCount
        && range.length == 0
        && range.location + 1 >= idTextFieldMaxCount)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }

        return idLengthValidate(text: text, range: range)
    }
}
