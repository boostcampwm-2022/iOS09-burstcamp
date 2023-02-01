//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import Foundation

final class SignUpBlogViewModel {

    private let signUpUseCase: SignUpUseCase

    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }

    struct Input {
        let blogAddressTextFieldDidEdit: AnyPublisher<String, Never>
        let nextButtonDidTap: PassthroughSubject<Void, Never>
        let skipConfirmDidTap: PassthroughSubject<Void, Never>
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
            .map { [weak self] address in
                self?.signUpUseCase.setUserBlogURL(address)
                return self?.signUpUseCase.isValidateBlogURL(address) ?? false
            }
            .eraseToAnyPublisher()

        // 블로그 이름 확인
        let signUpWithNextButton = input.nextButtonDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .flatMap { _ in
                self.getBlogTitle()
            }
            .catch { _ in
                return Just("").eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        // blog와 함께 가입
        let signUpWithBlogTitle = input.blogTitleConfirmDidTap
            .flatMap { blogTitle in
                self.signUp(blogTitle: blogTitle)
            }
            .eraseToAnyPublisher()

        // blog 없이 가입
        let signUpWithSkipButton = input.skipConfirmDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .flatMap { _ in
                self.signUp()
            }
            .eraseToAnyPublisher()

        return Output(
            validateBlogAddress: validateBlogAddress,
            signUpWithNextButton: signUpWithNextButton,
            signUpWithBlogTitle: signUpWithBlogTitle,
            signUpWithSkipButton: signUpWithSkipButton
        )
    }

    private func getBlogTitle() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task { [weak self] in
                do {
                    guard let self = self else {
                        throw SignUpBlogViewModelError.getBlogTitle
                    }
                    let blogURL = self.signUpUseCase.getUserBlogURL()
                    let blogTitle = try await self.signUpUseCase.getBlogTitle(blogURL: blogURL)

                    promise(.success(blogTitle))
                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func signUp(blogTitle: String = "") -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Task { [weak self] in
                do {
                    let userUUID = UserManager.shared.user.userUUID
                    guard let user = try self?.signUpUseCase.getUser(userUUID: userUUID, blogTitle: blogTitle) else {
                        throw SignUpBlogViewModelError.createUser
                    }

                    if blogTitle.isEmpty { assert(user.blogURL.isEmpty) }
                    try await self?.signUpUseCase.signUp(user)
                    self?.saveFCMToken()
                    promise(.success(user))
                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func saveFCMToken() {
        guard let fcmToken = UserDefaultsManager.fcmToken() else { return }
        let userUUID = UserManager.shared.user.userUUID
        Task { [weak self] in
            try await self?.signUpUseCase.saveFCMToken(fcmToken, to: userUUID)
        }
    }
}
