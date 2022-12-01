//
//  LogInViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Combine
import Foundation

final class LogInViewModel {

    private var cancelBag = Set<AnyCancellable>()

    struct Input {
        let logInButton: AnyPublisher<Void, Never>
    }

    struct Output {
        let logInPublisher: AnyPublisher<AuthCoordinatorEvent, Never>
    }

    func transform(input: Input) -> Output {
        input.logInButton
            .sink {
                LogInManager.shared.openGithubLoginView()
            }
            .store(in: &cancelBag)

        let logInPublisher = LogInManager.shared.logInPublisher.eraseToAnyPublisher()

        return Output(logInPublisher: logInPublisher)
    }
}
