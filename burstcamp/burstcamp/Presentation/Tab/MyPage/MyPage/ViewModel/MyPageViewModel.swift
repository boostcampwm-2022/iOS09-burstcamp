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
    private let bcFirestoreService = BCFirestoreService()

    private var updateUserValue = CurrentValueSubject<User, Never>(UserManager.shared.user)
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
        var moveToLoginFlow = PassthroughSubject<Void, Never>()
        var withdrawalStop = PassthroughSubject<Void, Never>()
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

        let output = Output(
            updateUserValue: updateUserValue,
            signOutFailMessage: signOutFailMessage,
            withdrawalStop: withdrawalStop
        )

        UserManager.shared.userUpdatePublisher
            .sink { [weak self] user in
                self?.updateUserValue.send(user)
            }
            .store(in: &cancelBag)

        return output
    }

    func deleteUserInfo(code: String) async throws {
        do {
            try await myPageUseCase.withdrawal(code: code)
        } catch {
            print(error.localizedDescription)
            withdrawalStop.send()
            signOutFailMessage.send("탈퇴에 실패했어요.")
        }
    }
}
