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

    private let myPageEditUseCase: MyPageEditUseCase
    private var cancelBag = Set<AnyCancellable>()

    init(myPageEditUseCase: MyPageEditUseCase) {
        self.myPageEditUseCase = myPageEditUseCase
    }

    struct Input {
        let imagePickerPublisher: PassthroughSubject<Data?, Never>
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
            .sink { profileImageData in
                self.myPageEditUseCase.setImageData(profileImageData)
            }
            .store(in: &cancelBag)

        input.nickNameTextFieldDidEdit
            .sink { nickname in
                self.myPageEditUseCase.setUserNickname(nickname)
            }
            .store(in: &cancelBag)

        input.blogLinkFieldDidEdit
            .sink { blogURL in
                self.myPageEditUseCase.setUserBlogURL(blogURL)
            }
            .store(in: &cancelBag)
    }

    private func createOutput(from input: Input) -> Output {
        let output = Output()

        input.finishEditButtonDidTap
            .sink { _ in
                let validationResult = self.myPageEditUseCase.validateResult()
                output.validationResult.send(validationResult)
                if case .validationOK = validationResult {
                    self.updateUser()
                }
            }
            .store(in: &cancelBag)

        return output
    }

    func updateUser() {
        Task { [weak self] in
            do {
                try await self?.myPageEditUseCase.updateUser()
            } catch {
                debugPrint(error)
            }
        }
    }
}
