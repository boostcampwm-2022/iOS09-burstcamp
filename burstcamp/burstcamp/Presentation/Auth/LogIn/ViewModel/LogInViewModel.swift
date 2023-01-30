//
//  LogInViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Combine
import Foundation

final class LogInViewModel {

    private let loginUseCase: LoginUseCase
    private var logInPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    struct Input {
        let logInButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let openLogInView: AnyPublisher<Void, Never>
        let moveToOtherView: AnyPublisher<AuthCoordinatorEvent, Never>
    }

    func transform(input: Input) -> Output {
        let openLogInView = input.logInButtonDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()

        let moveToOtherView = logInPublisher
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()

        return Output(
            openLogInView: openLogInView,
            moveToOtherView: moveToOtherView
        )
    }

    func loginWithGithub(code: String) async throws {
        let (userNickname, userUUID) = try await loginUseCase.loginWithGithub(code: code)
        UserManager.shared.setUserUUID(userUUID)

        let isUserExist = try await loginUseCase.checkIsExist(userUUID: userUUID)
        if isUserExist {
            logInPublisher.send(.moveToTabBarScreen)
        } else {
            logInPublisher.send(.moveToDomainScreen(userNickname: userNickname))
        }
    }

    func loginWithApple(idTokenString: String, nonce: String) async throws {
        let userUUID = try await loginUseCase.loginWithApple(idTokenString: idTokenString, nonce: nonce)
        UserManager.shared.setUserUUID(userUUID)

        let isUserExist = try await loginUseCase.checkIsExist(userUUID: userUUID)
        if isUserExist {
            logInPublisher.send(.moveToTabBarScreen)
        } else {
            // Guest로 계정 생성
        }
    }
}
