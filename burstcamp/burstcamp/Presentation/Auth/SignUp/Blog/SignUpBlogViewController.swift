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
        let nextButtonSubject = PassthroughSubject<Void, Never>()
        let skipConfirmSubject = PassthroughSubject<Void, Never>()
        let blogTitleConfirmSubject = PassthroughSubject<String, Never>()
        let saveFCMToken = PassthroughSubject<Void, Never>()

        signUpBlogView.skipButton.tapPublisher
            .sink { [weak self] _ in
                let confirmAction = UIAlertAction(title: "예", style: .default) { _ in
                    skipConfirmSubject.send()
                    self?.signUpBlogView.activityIndicator.startAnimating()
                    self?.signUpBlogView.signUpLabel.isHidden = false
                    self?.signUpBlogView.nextButton.isEnabled = false
                }
                let cancelAction = UIAlertAction(title: "아니오", style: .destructive)
                self?.showAlert(
                    message: "블로그가 없으신가요?",
                    alertActions: [cancelAction, confirmAction]
                )
            }
            .store(in: &cancelBag)

        signUpBlogView.nextButton.tapPublisher
            .sink { [weak self] _ in
                nextButtonSubject.send()
                self?.signUpBlogView.activityIndicator.startAnimating()
                self?.signUpBlogView.confirmBlogLabel.isHidden = false
                self?.signUpBlogView.nextButton.isEnabled = false
            }
            .store(in: &cancelBag)

        let input = SignUpBlogViewModel.Input(
            blogAddressTextFieldDidEdit: signUpBlogView.blogTextField.textPublisher,
            nextButtonDidTap: nextButtonSubject,
            skipConfirmDidTap: skipConfirmSubject,
            blogTitleConfirmDidTap: blogTitleConfirmSubject,
            saveFCMToken: saveFCMToken
        )

        let output = viewModel.transform(input: input)

        output.validateBlogAddress
            .sink { [weak self] validate in
                self?.signUpBlogView.nextButton.isEnabled = validate
                self?.signUpBlogView.nextButton.alpha = validate ? 1.0 : 0.3
            }
            .store(in: &cancelBag)

        output.signUpWithNextButton
            .sink { [weak self] blogTitle in
                DispatchQueue.main.async {
                    self?.signUpBlogView.activityIndicator.stopAnimating()
                    self?.signUpBlogView.confirmBlogLabel.isHidden = true
                    self?.signUpBlogView.nextButton.isEnabled = true

                    if blogTitle.isEmpty {
                        self?.showAlert(message: "블로그 주소를 확인해주세요.")
                    } else {
                        let confirmAction = UIAlertAction(title: "네", style: .default) { _ in
                            blogTitleConfirmSubject.send(blogTitle)
                            self?.signUpBlogView.activityIndicator.startAnimating()
                            self?.signUpBlogView.signUpLabel.isHidden = false
                            self?.signUpBlogView.nextButton.isEnabled = false
                        }
                        let cancelAction = UIAlertAction(title: "아니오", style: .destructive)
                        self?.showAlert(
                            message: "\(blogTitle) 블로그가 맞나요?",
                            alertActions: [cancelAction, confirmAction]
                        )
                    }
                }
            }
            .store(in: &cancelBag)

        output.signUpWithBlogTitle
            .sink(receiveCompletion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.signUpBlogView.activityIndicator.stopAnimating()
                    self?.signUpBlogView.signUpLabel.isHidden = true
                    self?.signUpBlogView.nextButton.isEnabled = true
                    if case .failure = result {
                        self?.showAlert(message: "회원가입에 실패했습니다.")
                    }
                }
            }, receiveValue: { [weak self] _ in
                saveFCMToken.send()
                self?.coordinatorPublisher.send(.moveToTabBarFlow)
            })
            .store(in: &cancelBag)

        output.signUpWithSkipButton
            .sink(receiveCompletion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.signUpBlogView.activityIndicator.stopAnimating()
                    self?.signUpBlogView.signUpLabel.isHidden = true
                    self?.signUpBlogView.nextButton.isEnabled = true
                    if case .failure = result {
                        self?.showAlert(message: "회원가입에 실패했습니다.")
                    }
                }
            }, receiveValue: { [weak self] _ in
                saveFCMToken.send()
                self?.coordinatorPublisher.send(.moveToTabBarFlow)
            })
            .store(in: &cancelBag)
    }
}
