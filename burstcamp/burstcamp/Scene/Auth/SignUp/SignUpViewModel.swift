//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import Foundation

final class SignUpViewModel {
    var domain: Domain = .iOS
    var camperID: String = ""
    var blogAddress: String = ""

    let userUUID: String
    let nickname: String

    private var cancelBag = Set<AnyCancellable>()

    struct InputDomain {
        let domainButtonDidTap: PassthroughSubject<Domain, Never>
    }

    struct InputCamperID {
        let camperIDTextFieldDidEdit: AnyPublisher<String, Never>
    }

    struct InputBlogAddress {
        let blogAddressTextFieldDidEdit: AnyPublisher<String, Never>
    }

    struct OutputCamperID {
        let validateCamperID: AnyPublisher<Bool, Never>
    }

    struct OutputBlogAddress {
        let validateBlogAddress: AnyPublisher<Bool, Never>
    }

    init(userUUID: String, nickname: String) {
        self.userUUID = userUUID
        self.nickname = nickname
    }

    func transformDomain(input: InputDomain) {
        input.domainButtonDidTap
            .sink { domain in
                self.domain = domain
            }
            .store(in: &cancelBag)
    }

    func transformCamperID(input: InputCamperID) -> OutputCamperID {
        let camperID = input.camperIDTextFieldDidEdit
            .map { id in
                self.camperID = id
                return id.count == 3 ? true : false
            }
            .eraseToAnyPublisher()
        return OutputCamperID(validateCamperID: camperID)
    }

    func transformBlogAddress(input: InputBlogAddress) -> OutputBlogAddress {
        let blogAddress = input.blogAddressTextFieldDidEdit
            .map { address in
                self.blogAddress = address
                return Validation.validate(blogLink: address) ? true : false
            }
            .eraseToAnyPublisher()

        return OutputBlogAddress(validateBlogAddress: blogAddress)
    }
}
