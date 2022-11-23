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
        let darkModeValueChanged: AnyPublisher<Appearance, Never>
    }

    struct Output {
        let darkModeInitialValue: Just<Appearance>
    }

    func transform(input: Input, cancelBag: inout Set<AnyCancellable>) -> Output {
        let output = Output(
            darkModeInitialValue: Just<Appearance>(
                DarkModeManager.currentAppearance
            )
        )

        input.darkModeValueChanged
            .sink { appearance in
                DarkModeManager.currentAppearance = appearance
            }
            .store(in: &cancelBag)

        return output
    }
}
