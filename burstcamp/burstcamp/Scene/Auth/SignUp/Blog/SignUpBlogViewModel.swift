//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import Foundation

final class SignUpBlogViewModel {

    var blogAddress: String = ""

    private var cancelBag = Set<AnyCancellable>()

    struct Input {
        let blogAddressTextFieldDidEdit: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<Void, Never>
        let skipConfirmDidTap: PassthroughSubject<Bool, Never>
    }

    struct Output {
        let validateBlogAddress: AnyPublisher<Bool, Never>
        let nextButton: AnyPublisher<User, FirestoreError>
        let skipButton: AnyPublisher<User, FirestoreError>
    }

    func transform(input: Input) -> Output {
        let blogAddressPublisher = input.blogAddressTextFieldDidEdit
            .map { address in
                self.blogAddress = address
                UserManager.shared.blogURL = address
                return Validation.validate(blogLink: address) ? true : false
            }
            .eraseToAnyPublisher()

        let nextButtonPublisher = input.nextButtonDidTap
            .flatMap { _ in
                return FireFunctionsManager.blogTitle(link: self.blogAddress).eraseToAnyPublisher()
            }
            .mapError { _ in FirestoreError.noDataError }
            .flatMap { title in
                let user = self.createUser(blogURL: self.blogAddress, blogTitle: title)
                return FirebaseUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        let skipButtonPublisher = input.skipConfirmDidTap
            .flatMap { _ in
                let user = self.createUser(blogURL: "", blogTitle: "")
                return FirebaseUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return Output(
            validateBlogAddress: blogAddressPublisher,
            nextButton: nextButtonPublisher,
            skipButton: skipButtonPublisher
        )
    }

    private func createUser(blogURL: String, blogTitle: String) -> User {
        return User(
            userUUID: UserManager.shared.userUUID,
            nickname: UserManager.shared.nickname,
            profileImageURL: "https://github.com/\(UserManager.shared.nickname).png",
            domain: UserManager.shared.domain,
            camperID: UserManager.shared.camperID,
            ordinalNumber: 7,
            blogURL: blogURL,
            blogTitle: blogTitle,
            scrapFeedUUIDs: [],
            signupDate: Date(),
            isPushOn: false
        )
    }
}
