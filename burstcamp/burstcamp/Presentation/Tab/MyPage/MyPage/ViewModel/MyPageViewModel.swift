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

    private var updateUserValue = CurrentValueSubject<User, Never>(UserManager.shared.user)
    private var loginProviderPublisher = PassthroughSubject<LoginProvider, Never>()
    private var withdrawalStop = PassthroughSubject<Void, Never>()
    private var signOutFailMessage = PassthroughSubject<String, Never>()

    init(myPageUseCase: MyPageUseCase) {
        self.myPageUseCase = myPageUseCase
    }

    struct Input {
        let notificationDidSwitch: AnyPublisher<Bool, Never>
        let darkModeDidSwitch: AnyPublisher<Bool, Never>
        let withdrawDidTap: PassthroughSubject<Void, Never>
    }

    struct Output {
        var updateUserValue = CurrentValueSubject<User, Never>(UserManager.shared.user)
        var darkModeInitialValue = Just<Appearance>(DarkModeManager.currentAppearance)
        var appVersionValue = Just<String>(
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        )
        var signOutFailMessage = PassthroughSubject<String, Never>()
        var withdrawalStop = PassthroughSubject<Void, Never>()
        var loginProviderPublisher: AnyPublisher<LoginProvider, Never>
    }

    private var cancelBag = Set<AnyCancellable>()

    func transform(input: Input) -> Output {
        input.notificationDidSwitch
            .sink { isOn in
                let userUUID = UserManager.shared.user.userUUID
                Task { [weak self] in
                    try await self?.myPageUseCase.updateUserPushState(userUUID: userUUID, isPushOn: isOn)
                }
            }
            .store(in: &cancelBag)

        input.darkModeDidSwitch
            .compactMap { Appearance.appearance(isOn: $0) }
            .sink { appearance in
                self.myPageUseCase.updateUserDarkModeState(appearance: appearance)
            }
            .store(in: &cancelBag)

        input.withdrawDidTap
            .sink { [weak self] _ in
                self?.sendUserProvider()
            }
            .store(in: &cancelBag)

        let output = Output(
            updateUserValue: updateUserValue,
            signOutFailMessage: signOutFailMessage,
            withdrawalStop: withdrawalStop,
            loginProviderPublisher: loginProviderPublisher.eraseToAnyPublisher()
        )

        UserManager.shared.userUpdatePublisher
            .sink { [weak self] user in
                self?.myPageUseCase.updateLocalUser(user)
                self?.updateUserValue.send(user)
            }
            .store(in: &cancelBag)

        return output
    }

    private func sendUserProvider() {
        if updateUserValue.value.domain == .guest {
            loginProviderPublisher.send(.apple)
        } else {
            loginProviderPublisher.send(.github)
        }
    }
}

extension MyPageViewModel {
    func deleteUserInfo(code: String) async throws {
        do {
            try await myPageUseCase.withdrawalWithGithub(code: code, userUUID: UserManager.shared.user.userUUID)
        } catch {
            print(error.localizedDescription)
            withdrawalStop.send()
            signOutFailMessage.send("탈퇴에 실패했어요.")
        }
    }
}
