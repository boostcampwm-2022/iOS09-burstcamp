//
//  LogInViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import AuthenticationServices
import Combine
import Foundation

final class LogInViewModel {

    private let loginUseCase: LoginUseCase

    private var logInPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    struct Input {
        let githubLogInButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let openGithubLogInView: AnyPublisher<Void, Never>
        let moveToOtherView: AnyPublisher<AuthCoordinatorEvent, Never>
    }

    func transform(input: Input) -> Output {
        let openLogInView = input.githubLogInButtonDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()

        let moveToOtherView = logInPublisher
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()

        return Output(
            openGithubLogInView: openLogInView,
            moveToOtherView: moveToOtherView
        )
    }

    func loginWithGithub(code: String) async throws {
        let (userNickname, userUUID) = try await loginUseCase.loginWithGithub(code: code)
        UserManager.shared.setUserUUID(userUUID)

        let isUserExist = try await loginUseCase.checkIsExist(userUUID: userUUID)
        if isUserExist {
            UserManager.shared.addUserListener()
            logInPublisher.send(.moveToTabBarScreen)
        } else {
            logInPublisher.send(.moveToDomainScreen(userNickname: userNickname))
        }
    }

    func loginWithApple(idTokenString: String, nonce: String) async throws {
        let userUUID = try await loginUseCase.loginWithApple(idTokenString: idTokenString, nonce: nonce)
        UserManager.shared.setUserUUID(userUUID)

        let isUserExist = try await loginUseCase.checkIsExist(userUUID: userUUID)
        if !isUserExist {
            try await loginUseCase.createGuest(userUUID: userUUID)
        }
        UserManager.shared.addUserListener()
        logInPublisher.send(.moveToTabBarScreen)
    }
}
