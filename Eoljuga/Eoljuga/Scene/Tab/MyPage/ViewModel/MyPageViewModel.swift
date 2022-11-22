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
        let darkmodeValueChanged: AnyPublisher<Appearance, Never>
    }

    struct Output {
        let darkmodeInitialValue: CurrentValueSubject<Appearance, Never>
    }

    func transform(input: Input, cancelBag: inout Set<AnyCancellable>) -> Output {
        let output = Output(
            darkmodeInitialValue: CurrentValueSubject<Appearance, Never>(
                DarkModeManager.appearance()
            )
        )

        input.darkmodeValueChanged
            .sink { appearance in
                DarkModeManager.setAppearance(appearance)
            }
            .store(in: &cancelBag)

        return output
    }
}
