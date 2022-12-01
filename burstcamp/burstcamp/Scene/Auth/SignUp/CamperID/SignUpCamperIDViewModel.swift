//
//  SignUpCamperIDViewModel.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/01.
//

import Combine
import Foundation

final class SignUpCamperIDViewModel {

    var camperID: String = ""

    struct Input {
        let camperIDTextFieldDidEdit: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let validateCamperID: AnyPublisher<Bool, Never>
        let moveToBlogView: AnyPublisher<Void, Never>
        let domainText: Just<String>
        let representingDomainText: Just<String>
    }

    func transform(input: Input) -> Output {
        let validateCamperID = input.camperIDTextFieldDidEdit
            .map { id in
                self.camperID = id
                UserManager.shared.camperID = id
                return id.count == 3 ? true : false
            }
            .eraseToAnyPublisher()

        let moveToBlogView = input.nextButtonDidTap

        let domainText = Just(UserManager.shared.domain.rawValue)

        let representingDomainText = Just(UserManager.shared.domain.representingDomain)

        return Output(
            validateCamperID: validateCamperID,
            moveToBlogView: moveToBlogView,
            domainText: domainText,
            representingDomainText: representingDomainText
        )
    }
}
