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
        signUpBlogView.nextButton.tapPublisher
            .sink {
                self.nextButtonDidTap()
            }
            .store(in: &cancelBag)

        signUpBlogView.skipButton.tapPublisher
            .sink {
                self.showSkipBlogAlert()
            }
            .store(in: &cancelBag)

        let textPublisher = signUpBlogView.blogTextField.textPublisher

        let input = SignUpViewModel.InputBlogAddress(blogAddressTextFieldDidEdit: textPublisher)

        viewModel.transformBlogAddress(input: input)
            .validateBlogAddress
            .sink { validate in
                self.signUpBlogView.nextButton.isEnabled = validate
                self.signUpBlogView.nextButton.alpha = validate ? 1.0 : 0.3
            }
            .store(in: &cancelBag)
    }

    private func makeUser(blogURL: String, blogTitle: String) -> User {
        return User(
            userUUID: viewModel.userUUID,
            nickname: viewModel.nickname,
            profileImageURL: "https://github.com/\(viewModel.nickname).png",
            domain: viewModel.domain,
            camperID: viewModel.camperID,
            ordinalNumber: 7,
            blogURL: blogURL,
            blogTitle: blogTitle,
            scrapFeedUUIDs: [],
            signupDate: Date(),
            isPushOn: false
        )
    }

    private func showSkipBlogAlert() {
        let sheet = UIAlertController(
            title: "경고",
            message: "블로그가 없으신가요?",
            preferredStyle: .alert
        )

        sheet.addAction(
            UIAlertAction(title: "네", style: .default) { _ in
                let user = self.makeUser(blogURL: "", blogTitle: "")
                let saveUser = FirebaseUser.save(user: user).eraseToAnyPublisher()

                self.switchProcess(publisher: saveUser)
            }
        )
        sheet.addAction(
            UIAlertAction(title: "아니요", style: .cancel)
        )

        present(sheet, animated: false)
    }

    private func nextButtonDidTap() {
        let saveUser = FireFunctionsManager.blogTitle(link: viewModel.blogAddress)
            .mapError { _ in FirestoreError.noDataError }
            .flatMap { title in
                let user = self.makeUser(blogURL: self.viewModel.blogAddress, blogTitle: title)
                return FirebaseUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        switchProcess(publisher: saveUser)
    }

    private func switchProcess(publisher: AnyPublisher<User, FirestoreError>) {
        publisher
        .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                return
            case .failure(let error):
                self.showBasicAlert(title: "경고", message: "회원가입에 실패했습니다")
            }
        }, receiveValue: { _ in
            // TODO: 싱글톤에 저장
            self.coordinatorPublisher.send(.moveToTabBarFlow)
        })
        .store(in: &cancelBag)
    }
}
