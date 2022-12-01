//
//  SignUpBlogViewController.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/20.
//

import Combine
import UIKit

final class SignUpBlogViewController: UIViewController {

    private var signUpBlogView: SignUpBlogView {
        guard let view = view as? SignUpBlogView else { return SignUpBlogView() }
        return view
    }

    var coordinatorPublisher = PassthroughSubject<AppCoordinatorEvent, Never>()
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
        self.view = SignUpBlogView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        let skipConfirmSubject = PassthroughSubject<Bool, Never>()

        signUpBlogView.skipButton.tapPublisher
            .sink { _ in
                let confirmAction = UIAlertAction(title: "네", style: .default) { _ in
                    skipConfirmSubject.send(true)
                }
                let cancelAction = UIAlertAction(title: "아니오", style: .destructive)
                self.showAlert(
                    title: "경고",
                    message: "블로그가 없으신가요?",
                    alertActions: [confirmAction, cancelAction]
                )
            }
            .store(in: &cancelBag)

        let textPublisher = signUpBlogView.blogTextField.textPublisher
        let nextButtonPublisher = signUpBlogView.nextButton.tapPublisher

        let input = SignUpViewModel.InputBlogAddress(
            blogAddressTextFieldDidEdit: textPublisher,
            nextButtonDidTap: nextButtonPublisher,
            skipConfirmDidTap: skipConfirmSubject
        )

        viewModel.transformBlogAddress(input: input)
            .validateBlogAddress
            .sink { validate in
                self.signUpBlogView.nextButton.isEnabled = validate
                self.signUpBlogView.nextButton.alpha = validate ? 1.0 : 0.3
            }
            .store(in: &cancelBag)

        viewModel.transformBlogAddress(input: input)
            .nextButton
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    self.showAlert(title: "경고", message: "회원가입에 실패했습니다")
                }
            }, receiveValue: { _ in
                // TODO: 싱글톤에 저장
                self.coordinatorPublisher.send(.moveToTabBarFlow)
            })
            .store(in: &cancelBag)

        viewModel.transformBlogAddress(input: input)
            .skipButton
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    self.showAlert(title: "경고", message: "회원가입에 실패했습니다")
                }
            }, receiveValue: { _ in
                // TODO: 싱글톤에 저장
                self.coordinatorPublisher.send(.moveToTabBarFlow)
            })
            .store(in: &cancelBag)
    }
}
