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

    func login(code: String) throws {
        Task { [weak self] in
            guard let (userNickname, userUUID) = try await self?.loginUseCase.login(code: code) else {
                throw LoginViewModelError.login
            }
            UserManager.shared.setUserUUID(userUUID)
            logInPublisher.send(.moveToDomainScreen(userNickname: userNickname))
        }
    }
}
