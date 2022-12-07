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
        let nextButtonDidTap: PassthroughSubject<Bool, Never>
        let skipConfirmDidTap: PassthroughSubject<Bool, Never>
        let blogTitleConfirmDidTap: PassthroughSubject<String, Never>
    }

    struct Output {
        let validateBlogAddress: AnyPublisher<Bool, Never>
        let signUpWithNextButton: AnyPublisher<String, Never>
        let signUpWithBlogTitle: AnyPublisher<User, Error>
        let signUpWithSkipButton: AnyPublisher<User, Error>
    }

    func transform(input: Input) -> Output {
        let validateBlogAddress = input.blogAddressTextFieldDidEdit
            .map { address in
                LogInManager.shared.blodURL = address
                return Validation.validate(blogLink: address) ? true : false
            }
            .eraseToAnyPublisher()

        let signUpWithNextButton = input.nextButtonDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .flatMap { _ in
                return FireFunctionsManager.blogTitle(
                    link: LogInManager.shared.blodURL
                )
                .eraseToAnyPublisher()
            }
            .catch { _ in
                return Just("").eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        let signUpWithBlogTitle = input.blogTitleConfirmDidTap
            .flatMap { title -> AnyPublisher<User, Error> in
                return Future<User, Error> { promise in
                    guard let user = try? self.createUser(
                        blogURL: LogInManager.shared.blodURL,
                        blogTitle: title
                    ) else {
                        promise(.failure(FirestoreError.noDataError))
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
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .flatMap { _ -> AnyPublisher<User, Error> in
                return Future<User, Error> { promise in
                    guard let user = try? self.createUser(blogURL: "", blogTitle: "") else {
                        promise(.failure(FirestoreError.noDataError))
                        return
                    }
                    promise(.success(user))
                }
                .eraseToAnyPublisher()
            }
            .flatMap { user -> AnyPublisher<User, Error> in
                return FirestoreUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return Output(
            validateBlogAddress: validateBlogAddress,
            signUpWithNextButton: signUpWithNextButton,
            signUpWithBlogTitle: signUpWithBlogTitle,
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
