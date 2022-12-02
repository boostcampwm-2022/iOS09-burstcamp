//
//  SignUpDomainViewModel.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/01.
//

import Combine
import Foundation

final class SignUpDomainViewModel {

    var domain: Domain = .iOS

    struct Input {
        let webButtonTouchDown: AnyPublisher<Void, Never>
        let aosButtonTouchDown: AnyPublisher<Void, Never>
        let iosButtonTouchDown: AnyPublisher<Void, Never>
        let webButtonDidTap: AnyPublisher<Void, Never>
        let aosButtonDidTap: AnyPublisher<Void, Never>
        let iosButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let webButtonChangeColor: AnyPublisher<Domain, Never>
        let aosButtonChangeColor: AnyPublisher<Domain, Never>
        let iosButtonChangeColor: AnyPublisher<Domain, Never>
        let webSelected: AnyPublisher<Domain, Never>
        let aosSelected: AnyPublisher<Domain, Never>
        let iosSelected: AnyPublisher<Domain, Never>
    }

    func transform(input: Input) -> Output {
        let webButtonChangeColor = input.webButtonTouchDown
            .map { _ -> Domain in
                self.domain = .web
                return .web
            }
            .eraseToAnyPublisher()

        let aosButtonChangeColor = input.aosButtonTouchDown
            .map { _ -> Domain in
                self.domain = .android
                return .android
            }
            .eraseToAnyPublisher()

        let iosButtonChangeColor = input.iosButtonTouchDown
            .map { _ -> Domain in
                self.domain = .iOS
                return .iOS
            }
            .eraseToAnyPublisher()

        let webSelected = input.webButtonDidTap
            .map { _ -> Domain in
                self.domain = .web
                UserManager.shared.domain = .web
                return .web
            }
            .eraseToAnyPublisher()

        let aosSelected = input.aosButtonDidTap
            .map { _ -> Domain in
                self.domain = .android
                UserManager.shared.domain = .android
                return .android
            }
            .eraseToAnyPublisher()

        let iosSelected = input.iosButtonDidTap
            .map { _ -> Domain in
                self.domain = .iOS
                UserManager.shared.domain = .iOS
                return .iOS
            }
            .eraseToAnyPublisher()

        return Output(
            webButtonChangeColor: webButtonChangeColor,
            aosButtonChangeColor: aosButtonChangeColor,
            iosButtonChangeColor: iosButtonChangeColor,
            webSelected: webSelected,
            aosSelected: aosSelected,
            iosSelected: iosSelected
        )
    }
}
