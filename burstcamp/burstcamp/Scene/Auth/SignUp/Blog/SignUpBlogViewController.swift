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
                self.skipButtonDidTap()
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

    private func skipButtonDidTap() {
        // TODO: Alert창

        // TODO: 회원가입 성공시
        self.coordinatorPublisher.send(.moveToTabBarFlow)
    }

    private func nextButtonDidTap() {

        // TODO: 블로그 주소 검증

//        FireStoreService.save(
//            user: User(
//                userUUID: viewModel.userUUID,
//                nickname: viewModel.nickname,
//                profileImageURL: "https://github.com/\(viewModel.nickname).png",
//                domain: viewModel.domain,
//                camperID: viewModel.camperID,
//                blogUUID: "",
//                signupDate: "", // TODO: 노션DB에는 Date로, User모델에는 String으로. 확인 필요
//                scrapFeedUUIDs: [],
//                isPushOn: false
//            )
//        )
//        .receive(on: DispatchQueue.main)
//        .sink { result in
//            print(result)
//        } receiveValue: { data in
//            print(data)
//            self.coordinatorPublisher.send(.moveToTabBarFlow)
//        }.store(in: &cancelBag)
    }
}
