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
        var moveToLoginFlow = PassthroughSubject<Void, Never>()
    }

    func transform(input: Input, cancelBag: inout Set<AnyCancellable>) -> Output {
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
            .sink { _ in
                FirestoreUser.delete(user: UserManager.shared.user)
                // TODO: Feed 스크랩 정보 삭제
                // TODO: LoginManager 탈퇴 호출
                Auth.auth().currentUser?.delete() { _ in
                    output.moveToLoginFlow.send()
                }
            }
            .store(in: &cancelBag)

        return output
    }
}
