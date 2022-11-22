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

    private var cancelBag = Set<AnyCancellable>()
    var coordinatorPublisher = PassthroughSubject<(AuthCoordinatorEvent, SignUpViewModel), Never>()
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
        bind()
    }

    private func setDelegate() {
        signUpCamperIDView.idTextField.delegate = self
    }

    private func bind() {
        viewModel.$domain.sink { domain in
            self.signUpCamperIDView.domainLabel.text = domain.rawValue
            self.signUpCamperIDView.representingDomainLabel.text = domain.representingDomain
        }
        .store(in: &cancelBag)

        signUpCamperIDView.idTextField.addTarget(
            self,
            action: #selector(idDidChange(_:)),
            for: .editingChanged
        )

        signUpCamperIDView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTouchDown(_:)),
            for: .touchDown
        )

        signUpCamperIDView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTouchUpOutside(_:)),
            for: .touchUpOutside
        )

        signUpCamperIDView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTouchUpInside(_:)),
            for: .touchUpInside
        )
    }

    @objc private func idDidChange(_ sender: UITextField) {
        guard let id = sender.text else { return }
        viewModel.camperID = id
    }

    @objc private func nextButtonTouchDown(_ sender: UITextField) {
        sender.alpha = 0.5
    }

    @objc private func nextButtonTouchUpOutside(_ sender: UITextField) {
        sender.alpha = 1.0
    }

    @objc func nextButtonTouchUpInside(_ sender: UIButton) {
        sender.alpha = 1.0

        //TODO: 캠퍼ID 중복 확인

        coordinatorPublisher.send((.moveToBlogScreen, viewModel))
    }
}

extension SignUpCamperIDViewController: UITextFieldDelegate {
    private func idLengthValidate(text: String, range: NSRange) -> Bool {
        return !(text.count >= idTextFieldMaxCount
        && range.length == 0
        && range.location + 1 >= idTextFieldMaxCount)
    }

    private func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }

        return idLengthValidate(text: text, range: range)
    }
}
