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
            .flatMap { title -> AnyPublisher<User, FirestoreError> in
                return Future<User, FirestoreError> { promise in
                    guard let user = try? self.createUser(
                        blogURL: LogInManager.shared.blodURL,
                        blogTitle: title
                    ) else {
                        promise(.failure(.noDataError))
                        return
                    }
                    promise(.success(user))
                }
                .eraseToAnyPublisher()
            }
            .flatMap { user in
                return FirestoreUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        let signUpWithSkipButton = input.skipConfirmDidTap
            .flatMap { _ -> AnyPublisher<User, FirestoreError> in
                return Future<User, FirestoreError> { promise in
                    guard let user = try? self.createUser(blogURL: "", blogTitle: "") else {
                        promise(.failure(.noDataError))
                        return
                    }
                    promise(.success(user))
                }
                .eraseToAnyPublisher()
            }
            .flatMap { user -> AnyPublisher<User, FirestoreError> in
                return FirestoreUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return Output(
            validateBlogAddress: validateBlogAddress,
            signUpWithNextButton: signUpWithNextButton,
            signUpWithSkipButton: signUpWithSkipButton
        )
    }

    private func createUser(blogURL: String, blogTitle: String) throws -> User {
        guard let userUUID = LogInManager.shared.userUUID else {
            throw FirestoreError.noDataError
        }

        return User(
            userUUID: userUUID,
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
