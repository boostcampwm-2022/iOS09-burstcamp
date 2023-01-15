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

    private let myPageUseCase: MyPageUseCase
    private let bcFirestoreService = BCFirestoreService()

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
                let pushData = ["isPushOn": isOn]
                Task { [weak self] in
                    try await self?.bcFirestoreService.updateUser(userUUID: userUUID, data: pushData)
                }
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

        LogInManager.shared.withdrawalPublisher
            .sink { completion in
                if case .failure = completion {
                    output.signOutFailMessage.send("탈퇴에 실패했어요.")
                }
            } receiveValue: { isSignOut in
                if isSignOut {
                    self.deleteUserInfos(output: output)
                }
            }
            .store(in: &cancelBag)

        return output
    }

    private func deleteUserInfos(output: Output) {
        let userUUID = UserManager.shared.user.userUUID
        print(userUUID)
        KeyChainManager.deleteUser()
        //TODO: Listener 처리
//        UserManager.shared.removeUserListener()
        UserManager.shared.deleteUserInfo()
        FireFunctionsManager.deleteUser(userUUID: userUUID)
            .sink { _ in
            } receiveValue: { isFinish in
                if isFinish {
                    output.moveToLoginFlow.send()
                } else {
                    output.withdrawalStop.send()
                    output.signOutFailMessage.send("탈퇴 정보 삭제에 실패했어요.")
                }
            }
            .store(in: &cancelBag)
    }
}
