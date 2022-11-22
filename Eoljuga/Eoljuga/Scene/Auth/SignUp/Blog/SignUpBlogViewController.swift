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
            action: #selector(nextButtonTouchDown(_:)),
            for: .touchDown
        )

        signUpBlogView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTouchUpOutside(_:)),
            for: .touchUpOutside
        )

        signUpBlogView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTouchUpInside(_:)),
            for: .touchUpInside
        )
    }

    @objc private func blogTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.blogAddress = text
    }

    @objc private func skipButtonDidTouch() {
        coordinatorPublisher.send(.moveToTabBarFlow)
    }
    
    @objc private func idDidChange(_ sender: UITextField) {
        guard let id = sender.text else { return }
        viewModel.camperID = id
    }

    @objc private func nextButtonTouchDown(_ sender: UITextField) {
        sender.alpha = 0.5
    }

    @objc private func nextButtonTouchUpInside() {
        sender.alpha = 1.0
        
        //TODO: 블로그 주소 검증
        
        coordinatorPublisher.send(.moveToTabBarFlow)
    }
}
