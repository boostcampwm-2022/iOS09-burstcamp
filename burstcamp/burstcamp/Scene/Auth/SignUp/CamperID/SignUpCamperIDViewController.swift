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

    var coordinatorPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()
    private var cancelBag = Set<AnyCancellable>()

    private let viewModel: SignUpCamperIDViewModel
    private let idTextFieldMaxCount = 3

    init(viewModel: SignUpCamperIDViewModel) {
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
        bind()
    }

    private func setDelegate() {
        signUpCamperIDView.idTextField.delegate = self
    }

    private func bind() {
        let input = SignUpCamperIDViewModel.Input(
            camperIDTextFieldDidEdit: signUpCamperIDView.idTextField.textPublisher,
            nextButtonDidTap: signUpCamperIDView.nextButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.validateCamperID
            .sink { validate in
                self.signUpCamperIDView.nextButton.isEnabled = validate
                self.signUpCamperIDView.nextButton.alpha = validate ? 1.0 : 0.3
            }
            .store(in: &cancelBag)

        output.moveToBlogView
            .sink { _ in
                self.coordinatorPublisher.send(.moveToBlogScreen)
            }
            .store(in: &cancelBag)

        output.domainText
            .assign(to: \.text, on: signUpCamperIDView.domainLabel)
            .store(in: &cancelBag)

        output.representingDomainText
            .assign(to: \.text, on: signUpCamperIDView.representingDomainLabel)
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
