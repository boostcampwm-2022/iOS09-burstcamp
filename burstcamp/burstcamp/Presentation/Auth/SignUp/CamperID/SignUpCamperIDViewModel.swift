//
//  SignUpCamperIDViewModel.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/01.
//

import Combine
import Foundation

final class SignUpCamperIDViewModel {

    private let signUpUseCase: SignUpUseCase

    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
        self.camperDomain = signUpUseCase.getUserDomain()
    }

    let camperDomain: Domain
    var camperID: String = ""

    struct Input {
        let camperIDTextFieldDidEdit: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let validateCamperID: AnyPublisher<Bool, Never>
        let moveToBlogView: AnyPublisher<Void, Never>
        let bindDomainText: Just<String>
        let bindRepresentingDomainText: Just<String>
    }

    func transform(input: Input) -> Output {
        let validateCamperID = input.camperIDTextFieldDidEdit
            .map { id in
                self.camperID = id
                let fullCamperID = "\(self.camperDomain.representing)" + id
                self.signUpUseCase.setUserCamperID(fullCamperID)
                return id.count == 3 && id.allSatisfy { $0.isNumber } ? true : false
            }
            .eraseToAnyPublisher()

        let moveToBlogView = input.nextButtonDidTap

        let domainText = Just(camperDomain.rawValue)

        let representingDomainText = Just(camperDomain.representing)

        return Output(
            validateCamperID: validateCamperID,
            moveToBlogView: moveToBlogView,
            bindDomainText: domainText,
            bindRepresentingDomainText: representingDomainText
        )
    }
}
