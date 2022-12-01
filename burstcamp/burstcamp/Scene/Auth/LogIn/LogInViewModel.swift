//
//  LogInViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Combine
import Foundation

final class LogInViewModel {

    struct Input {
        let logInButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let openLogInView: AnyPublisher<Void, Never>
        let moveToOtherView: AnyPublisher<AuthCoordinatorEvent, Never>
    }

    func transform(input: Input) -> Output {
        let openLogInView = input.logInButtonDidTap

        let moveToOtherView = LogInManager.shared.logInPublisher.eraseToAnyPublisher()

        return Output(
            openLogInView: openLogInView,
            moveToOtherView: moveToOtherView
        )
    }
}
