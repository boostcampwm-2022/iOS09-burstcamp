//
//  MyPageViewModel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import Combine
import Foundation

import FirebaseAuth

final class MyPageViewModel {

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
    }

    private var cancelBag = Set<AnyCancellable>()

    func transform(input: Input) -> Output {
        input.notificationDidSwitch
            .sink { isOn in
                FirestoreUser.update(userUUID: UserManager.shared.user.userUUID, isPushOn: isOn)
            }
            .store(in: &cancelBag)

        input.darkModeDidSwitch
            .compactMap { Appearance.appearance(isOn: $0) }
            .sink { appearance in
                DarkModeManager.currentAppearance = appearance
            }
            .store(in: &cancelBag)

        let output = Output()

        UserManager.shared.userUpdatePublisher
            .sink { user in
                output.updateUserValue.send(user)
            }
            .store(in: &cancelBag)

        input.withdrawDidTap
            .sink { [weak self] _ in
                self?.signOut(output: output)
            }
            .store(in: &cancelBag)

        return output
    }

    private func signOut(output: Output) {
        LogInManager.shared.signOut()
            .sink { completion in
                if case .failure = completion {
                    output.signOutFailMessage.send("탈퇴에 실패했어요.")
                }
            } receiveValue: { isSignOut in
                if isSignOut {
                    KeyChainManager.deleteUser()
                    UserManager.shared.deleteUserInfo()
                    output.moveToLoginFlow.send()
                }
            }
            .store(in: &cancelBag)
    }
}
