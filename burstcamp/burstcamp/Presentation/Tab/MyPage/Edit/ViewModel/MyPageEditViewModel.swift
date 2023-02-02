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

    private var beforeUser = CurrentValueSubject<User, Never>(UserManager.shared.user)
    private var afterUser = CurrentValueSubject<User, Never>(UserManager.shared.user)
    private var changedProfileImage: Data?

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
        let editedUser: AnyPublisher<User, Never>
        let profileImage: AnyPublisher<Void, Never>
        let nicknameValidate: AnyPublisher<MyPageEditNicknameValidation?, Error>
        let blogResult: AnyPublisher<MyPageEditBlogValidation?, Never>
    }

    func transform(input: Input) -> Output {

        let editedUser = afterUser.eraseToAnyPublisher()

        let profileImage = input.imagePickerPublisher
            .map { [weak self] profileImageData in
                self?.setImageData(profileImageData)
                return
            }
            .eraseToAnyPublisher()

        let nicknameValidate = input.nickNameTextFieldDidEdit
            .asyncMap { [weak self] nickname in
                self?.setUserNickname(nickname)
                return try await self?.checkNicknameValidation(nickname)
            }
            .eraseToAnyPublisher()

        let blogResult = input.blogLinkFieldDidEdit
            .map { [weak self] blogURL in
                self?.setUserBlogURL(blogURL)
                return self?.checkBlogURLValidation(blogURL)
            }
            .eraseToAnyPublisher()

        let output = Output(
            editedUser: editedUser,
            profileImage: profileImage,
            nicknameValidate: nicknameValidate,
            blogResult: blogResult
        )

        return output
    }

    func checkNicknameValidation(_ nickname: String) async throws -> MyPageEditNicknameValidation {
        return try await myPageEditUseCase.isValidNickname(nickname)
    }

    func checkBlogURLValidation(_ blogURL: String) -> MyPageEditBlogValidation {
        return myPageEditUseCase.isValidBlogURL(blogURL)
    }

    func setUserNickname(_ nickname: String) {
        afterUser.value.setNickname(nickname)
    }

    func setUserBlogURL(_ blogURL: String) {
        afterUser.value.setBlogURL(blogURL)
    }

    func setImageData(_ imageData: Data?) {
        self.changedProfileImage = imageData
    }
}
