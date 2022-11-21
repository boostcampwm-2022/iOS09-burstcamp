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

    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()
    let viewModel: SignUpViewModel

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
        signUpBlogView.blogTextField.addTarget(
            self,
            action: #selector(blogTextFieldChanged(_:)),
            for: .editingChanged
        )

        signUpBlogView.skipButton.addTarget(
            self,
            action: #selector(skipButtonDidTouch),
            for: .touchUpInside
        )

        signUpBlogView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTouch),
            for: .touchUpInside
        )
    }

    @objc func blogTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.blogAddress = text
    }

    @objc func skipButtonDidTouch() {
        coordinatorPublisher.send(.moveToTabBarFlow)
    }

    @objc func nextButtonDidTouch() {
        coordinatorPublisher.send(.moveToTabBarFlow)
    }
}
