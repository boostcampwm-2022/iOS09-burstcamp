//
//  MyPageViewModel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import Combine
import Foundation

final class MyPageViewModel {

    struct Input {
        let notificationIsOn: AnyPublisher<Bool, Never>
        let darkModeValueChanged: AnyPublisher<Appearance, Never>
    }

    struct Output {
        let userInitialValue: Just<User>
        let darkModeInitialValue: Just<Appearance>
    }

    func transform(input: Input, cancelBag: inout Set<AnyCancellable>) -> Output {
        let output = Output(
            userInitialValue: Just<User>(
                UserManager.shared.user
            ),
            darkModeInitialValue: Just<Appearance>(
                DarkModeManager.currentAppearance
            )
        )

        input.notificationIsOn
            .sink { isOn in
                FirestoreUser.update(userUUID: UserManager.shared.user.userUUID, isPushOn: isOn)
            }
            .store(in: &cancelBag)

        input.darkModeValueChanged
            .sink { appearance in
                DarkModeManager.currentAppearance = appearance
            }
            .store(in: &cancelBag)

        return output
    }
}
