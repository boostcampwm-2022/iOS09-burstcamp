//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import UIKit

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
        let nextButtonDidTap: AnyPublisher<Void, Never>
        let skipConfirmDidTap: PassthroughSubject<Bool, Never>
    }

    struct OutputCamperID {
        let validateCamperID: AnyPublisher<Bool, Never>
    }

    struct OutputBlogAddress {
        let validateBlogAddress: AnyPublisher<Bool, Never>
        let nextButton: AnyPublisher<User, FirestoreError>
        let skipButton: AnyPublisher<User, FirestoreError>
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
        let blogAddressPublisher = input.blogAddressTextFieldDidEdit
            .map { address in
                self.blogAddress = address
                return Validation.validate(blogLink: address) ? true : false
            }
            .eraseToAnyPublisher()

        let nextButtonPublisher = input.nextButtonDidTap
            .flatMap { _ in
                return FireFunctionsManager.blogTitle(link: self.blogAddress).eraseToAnyPublisher()
            }
            .mapError { _ in FirestoreError.noDataError }
            .flatMap { title in
                let user = self.createUser(blogURL: self.blogAddress, blogTitle: title)
                return FirebaseUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        let skipButtonPublisher = input.skipConfirmDidTap
            .flatMap { _ in
                let user = self.createUser(blogURL: "", blogTitle: "")
                return FirebaseUser.save(user: user).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return OutputBlogAddress(
            validateBlogAddress: blogAddressPublisher,
            nextButton: nextButtonPublisher,
            skipButton: skipButtonPublisher
        )
    }

    private func createUser(blogURL: String, blogTitle: String) -> User {
        return User(
            userUUID: userUUID,
            nickname: nickname,
            profileImageURL: "https://github.com/\(nickname).png",
            domain: domain,
            camperID: camperID,
            ordinalNumber: 7,
            blogURL: blogURL,
            blogTitle: blogTitle,
            scrapFeedUUIDs: [],
            signupDate: Date(),
            isPushOn: false
        )
    }
}
