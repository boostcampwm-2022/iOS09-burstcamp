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

    private let viewModel: SignUpBlogViewModel

    init(viewModel: SignUpBlogViewModel) {
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
        let nextButtonSubject = PassthroughSubject<Bool, Never>()
        let skipConfirmSubject = PassthroughSubject<Bool, Never>()
        let blogTitleConfirmSubject = PassthroughSubject<String, Never>()

        signUpBlogView.skipButton.tapPublisher
            .sink { _ in
                let confirmAction = UIAlertAction(title: "네", style: .default) { _ in
                    skipConfirmSubject.send(true)
                    self.signUpBlogView.activityIndicator.startAnimating()
                }
                let cancelAction = UIAlertAction(title: "아니오", style: .destructive)
                self.showAlert(
                    message: "블로그가 없으신가요?",
                    alertActions: [cancelAction, confirmAction]
                )
            }
            .store(in: &cancelBag)

        signUpBlogView.nextButton.tapPublisher
            .sink { _ in
                self.signUpBlogView.activityIndicator.startAnimating()
                nextButtonSubject.send(true)
            }
            .store(in: &cancelBag)

        let input = SignUpBlogViewModel.Input(
            blogAddressTextFieldDidEdit: signUpBlogView.blogTextField.textPublisher,
            nextButtonDidTap: nextButtonSubject,
            skipConfirmDidTap: skipConfirmSubject,
            blogTitleConfirmDidTap: blogTitleConfirmSubject
        )

        let output = viewModel.transform(input: input)

        output.validateBlogAddress
            .sink { validate in
                self.signUpBlogView.nextButton.isEnabled = validate
                self.signUpBlogView.nextButton.alpha = validate ? 1.0 : 0.3
            }
            .store(in: &cancelBag)

        output.signUpWithNextButton
            .sink { blogTitle in
                self.signUpBlogView.activityIndicator.stopAnimating()

                if blogTitle.isEmpty {
                    self.showAlert(message: "블로그 주소를 확인해주세요")
                } else {
                    let confirmAction = UIAlertAction(title: "네", style: .default) { _ in
                        blogTitleConfirmSubject.send(blogTitle)
                        self.signUpBlogView.activityIndicator.startAnimating()
                    }
                    let cancelAction = UIAlertAction(title: "아니오", style: .destructive)
                    self.showAlert(
                        message: "\(blogTitle) 블로그가 맞으신가요??",
                        alertActions: [cancelAction, confirmAction]
                    )
                }
            }
            .store(in: &cancelBag)

        output.signUpWithBlogTitle
            .sink(receiveCompletion: { result in
                self.signUpBlogView.activityIndicator.stopAnimating()
                if case .failure = result {
                    self.showAlert(message: "회원가입에 실패했습니다")
                }
            }, receiveValue: { _ in
                self.coordinatorPublisher.send(.moveToTabBarFlow)
            })
            .store(in: &cancelBag)

        output.signUpWithSkipButton
            .sink(receiveCompletion: { result in
                self.signUpBlogView.activityIndicator.stopAnimating()
                if case .failure = result {
                    self.showAlert(message: "회원가입에 실패했습니다")
                }
            }, receiveValue: { _ in
                self.coordinatorPublisher.send(.moveToTabBarFlow)
            })
            .store(in: &cancelBag)
    }
}
