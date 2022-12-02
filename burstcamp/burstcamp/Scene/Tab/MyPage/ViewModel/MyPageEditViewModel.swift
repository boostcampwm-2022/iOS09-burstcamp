//
//  MyPageEditViewModel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import Combine
import Foundation
import UIKit.UIImage

final class MyPageEditViewModel {

    private var profileImage: UIImage?
    private var nickname = UserManager.shared.user.nickname
    private var blogURL = UserManager.shared.user.blogURL
    private var cancelBag = Set<AnyCancellable>()

    struct Input {
        let imagePickerPublisher: PassthroughSubject<UIImage?, Never>
        let nickNameTextFieldDidEdit: AnyPublisher<String, Never>
        let blogLinkFieldDidEdit: AnyPublisher<String, Never>
        let finishEditButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        var currentUserInfo = CurrentValueSubject<User, Never>(
            UserManager.shared.user
        )
        var validationResult = PassthroughSubject<MyPageEditValidationResult, Never>()
    }

    func transform(input: Input) -> Output {
        configureInput(input: input)
        return createOutput(from: input)
    }

    private func configureInput(input: Input) {

        input.imagePickerPublisher
            .sink { profileImage in
                self.profileImage = profileImage
            }
            .store(in: &cancelBag)

        input.nickNameTextFieldDidEdit
            .sink { nickname in
                self.nickname = nickname
            }
            .store(in: &cancelBag)

        input.blogLinkFieldDidEdit
            .sink { blogURL in
                self.blogURL = blogURL
            }
            .store(in: &cancelBag)
    }

    private func createOutput(from input: Input) -> Output {
        let output = Output()

        input.finishEditButtonDidTap
            .sink { _ in
                let validationResult = self.validate()
                output.validationResult.send(validationResult)
                if case .validationOK = validationResult {
                    self.saveUser()
                }
            }
            .store(in: &cancelBag)

        return output
    }

    private func validate() -> MyPageEditValidationResult {
        let nicknameValidation = Validation.validate(nickname: nickname)
        let blogLinkValidation = Validation.validate(blogLink: blogURL)
        if nicknameValidation && blogLinkValidation {
            return .validationOK
        } else if nicknameValidation {
            return .blogLinkError
        } else {
            return .nicknameError
        }
    }

    private func profilemageURL() -> AnyPublisher<String, Never> {
        guard let profileImage = profileImage else {
            return Just(UserManager.shared.user.profileImageURL).eraseToAnyPublisher()
        }
        return FireStorageService.save(image: profileImage)
            .catch { _ in Just("") }
            .eraseToAnyPublisher()
    }

    private func saveUser() {
        FireFunctionsManager
            .blogTitle(link: blogURL)
            .catch { _ in Just("") }
            .combineLatest(profilemageURL())
            .sink { blogTitle, profileImageURL in
                FirestoreUser.update(
                    userUUID: UserManager.shared.user.userUUID,
                    nickname: self.nickname,
                    profileImageURL: profileImageURL,
                    blogURL: self.blogURL,
                    blogTitle: blogTitle
                )
            }
            .store(in: &cancelBag)
    }
}
