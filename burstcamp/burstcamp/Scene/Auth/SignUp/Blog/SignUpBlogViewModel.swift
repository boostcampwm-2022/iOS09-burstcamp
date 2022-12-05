//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import Foundation

final class SignUpBlogViewModel {

    struct Input {
        let blogAddressTextFieldDidEdit: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<Void, Never>
        let skipConfirmDidTap: PassthroughSubject<Bool, Never>
    }

    struct Output {
        let validateBlogAddress: AnyPublisher<Bool, Never>
        let signUpWithNextButton: AnyPublisher<User, FirestoreError>
        let signUpWithSkipButton: AnyPublisher<User, FirestoreError>
    }

    func transform(input: Input) -> Output {
        let validateBlogAddress = input.blogAddressTextFieldDidEdit
            .map { address in
                LogInManager.shared.blodURL = address
                return Validation.validate(blogLink: address) ? true : false
            }
            .eraseToAnyPublisher()

        let signUpWithNextButton = input.nextButtonDidTap
            .flatMap { _ in
                return FireFunctionsManager.blogTitle(
                    link: LogInManager.shared.blodURL
                )
                .eraseToAnyPublisher()
            }
            .mapError { _ in FirestoreError.setDataError }
            .flatMap { title in
                let user = self.createUser(
                    blogURL: LogInManager.shared.blodURL,
                    blogTitle: title
                )
                return FirestoreUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        let signUpWithSkipButton = input.skipConfirmDidTap
            .flatMap { _ -> AnyPublisher<User, FirestoreError> in
                let user = self.createUser(blogURL: "", blogTitle: "")
                return FirestoreUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return Output(
            validateBlogAddress: validateBlogAddress,
            signUpWithNextButton: signUpWithNextButton,
            signUpWithSkipButton: signUpWithSkipButton
        )
    }

    private func createUser(blogURL: String, blogTitle: String) -> User {
        return User(
            userUUID: LogInManager.shared.userUUID,
            nickname: LogInManager.shared.nickname,
            profileImageURL: "https://github.com/\(LogInManager.shared.nickname).png",
            domain: LogInManager.shared.domain,
            camperID: LogInManager.shared.camperID,
            ordinalNumber: 7,
            blogURL: blogURL,
            blogTitle: blogTitle,
            scrapFeedUUIDs: [],
            signupDate: Date(),
            isPushOn: false
        )
    }
}
