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
        let profileImage: AnyPublisher<Void, Never>
        let nicknameValidate: AnyPublisher<Bool, Never>
        let blogResult: AnyPublisher<Void, Never>
        let validationResult: AnyPublisher<MyPageEditValidationResult?, Error>
    }

    func transform(input: Input) -> Output {

        let profileImage = input.imagePickerPublisher
            .map { [weak self] profileImageData in
                self?.myPageEditUseCase.setImageData(profileImageData)
                return
            }
            .eraseToAnyPublisher()

        let nicknameValidate = input.nickNameTextFieldDidEdit
            .map { nickname in
                self.myPageEditUseCase.setUserNickname(nickname)
                return true // 유효성 검사
            }
            .eraseToAnyPublisher()

        let blogResult = input.blogLinkFieldDidEdit
            .map { blogURL in
                self.myPageEditUseCase.setUserBlogURL(blogURL)
            }
            .eraseToAnyPublisher()

        let validationResult = input.finishEditButtonDidTap
            .asyncMap { [weak self] _ in
                let validationResult = self?.myPageEditUseCase.validateResult()
                if case .validationOK = validationResult {
                    try await self?.myPageEditUseCase.updateUser()
                }
                return validationResult
            }
            .eraseToAnyPublisher()

        let output = Output(
            profileImage: profileImage,
            nicknameValidate: nicknameValidate,
            blogResult: blogResult,
            validationResult: validationResult
        )

        return output
    }
}
