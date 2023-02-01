//
//  MyPageViewModel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import Combine
import Foundation

final class MyPageViewModel {

    private let myPageUseCase: MyPageUseCase

    private var user = UserManager.shared.user

    init(myPageUseCase: MyPageUseCase) {
        self.myPageUseCase = myPageUseCase
    }

    struct Input {
        let myInfoEditButtonTap: AnyPublisher<Void, Never>
        let notificationDidSwitch: AnyPublisher<Bool, Never>
        let darkModeDidSwitch: AnyPublisher<Bool, Never>
        let withdrawDidTap: PassthroughSubject<Void, Never>
    }

    struct Output {
        let updateUserValue: AnyPublisher<User, Error>
        let myInfoEdit: AnyPublisher<Bool, Never>
        let notificationValue: AnyPublisher<Bool, Error>
        let darkModeValue: AnyPublisher<Appearance, Never>
        let loginProvider: AnyPublisher<LoginProvider, Never>
        let appVersionValue: AnyPublisher<String, Never>
    }

    func transform(input: Input) -> Output {

        let viewDidLoad = Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let updateUserValue = UserManager.shared.userUpdatePublisher
            .merge(with: viewDidLoad)
            .tryMap { user in
                self.myPageUseCase.updateLocalUser(user)
                self.user = user
                return user
            }
            .eraseToAnyPublisher()

        let myInfoEditButtonTap = input.myInfoEditButtonTap
            .map { _ in
                self.canUpdateMyInfo()
            }
            .eraseToAnyPublisher()

        let notificationValue = input.notificationDidSwitch
            .asyncMap { [weak self] isOn in
                let userUUID = UserManager.shared.user.userUUID
                try await self?.myPageUseCase.updateUserPushState(userUUID: userUUID, isPushOn: isOn)
                return isOn
            }
            .eraseToAnyPublisher()

        let initialDarkModeValue = Just(DarkModeManager.currentAppearance)

        let darkModeValue = input.darkModeDidSwitch
            .compactMap { isOn in
                let appearance = Appearance.appearance(isOn: isOn)
                self.myPageUseCase.updateUserDarkModeState(appearance: appearance)
                return appearance
            }
            .merge(with: initialDarkModeValue)
            .eraseToAnyPublisher()

        let loginProvider = input.withdrawDidTap
            .map { _ in
                self.createLoginProvider()
            }
            .eraseToAnyPublisher()

        let appVersionValue = Just(getAppVersion()).eraseToAnyPublisher()

        let output = Output(
            updateUserValue: updateUserValue,
            myInfoEdit: myInfoEditButtonTap,
            notificationValue: notificationValue,
            darkModeValue: darkModeValue,
            loginProvider: loginProvider,
            appVersionValue: appVersionValue
        )

        return output
    }

    private func createLoginProvider() -> LoginProvider {
        if user.domain == .guest {
            return .apple
        } else {
            return .github
        }
    }

    private func canUpdateMyInfo() -> Bool {
        return myPageUseCase.canUpdateMyInfo()
    }

    private func getAppVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}

extension MyPageViewModel {
    func withdrawalWithGithub(code: String) async throws {
        try await myPageUseCase.withdrawalWithGithub(code: code)
    }

    func withdrawalWithApple(idTokenString: String, nonce: String) async throws {
        try await myPageUseCase.withdrawalWithApple(idTokenString: idTokenString, nonce: nonce)
    }

    func getNextUpdateDate() -> Date {
        return myPageUseCase.getNextUpdateDate()
    }
}
