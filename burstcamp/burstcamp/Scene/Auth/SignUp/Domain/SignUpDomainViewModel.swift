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
        let webButtonDidTap: AnyPublisher<Void, Never>
        let aosButtonDidTap: AnyPublisher<Void, Never>
        let iosButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let webSelected: AnyPublisher<Domain, Never>
        let aosSelected: AnyPublisher<Domain, Never>
        let iosSelected: AnyPublisher<Domain, Never>
    }

    func transform(input: Input) -> Output {
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
            webSelected: webSelected,
            aosSelected: aosSelected,
            iosSelected: iosSelected
        )
    }
}
