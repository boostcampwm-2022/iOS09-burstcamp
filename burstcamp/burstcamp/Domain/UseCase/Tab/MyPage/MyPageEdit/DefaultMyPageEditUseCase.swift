//
//  DefaultMyPageEditUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultMyPageEditUseCase: MyPageEditUseCase {

    private let imageRepository: ImageRepository
    private let userRepository: UserRepository

    init(imageRepository: ImageRepository, userRepository: UserRepository) {
        self.imageRepository = imageRepository
        self.userRepository = userRepository
    }

    func isValidNickname(_ nickname: String) async throws -> MyPageEditNicknameValidation {
        guard Validator.validate(nickname: nickname) else {
            return .regexError
        }

        guard try await !userRepository.isNicknameExist(nickname) else {
            return .duplicateError
        }

        return .success
    }

    func isValidBlogURL(_ blogURL: String) -> MyPageEditBlogValidation {
        return Validator.validateIsEmpty(blogLink: blogURL) ? .success : .regexError
    }

    func updateUser(user: User, imageData: Data?) async throws {
        let updateUser = user.setUpdateDate()
        let imageUpdateUser = try await updateFirestorageImage(imageData, to: updateUser)
        try await userRepository.updateUser(imageUpdateUser)
        UserManager.shared.setUser(imageUpdateUser)
    }

//    private func isUserChanged() -> Bool {
//        return editedUser != beforeUser
//    }
//
//    private func isUserBlogURLChanged() -> Bool {
//        return editedUser.blogURL != beforeUser.blogURL
//    }

    private func updateFirestorageImage(_ imageData: Data?, to user: User) async throws -> User {
        // 새로운 이미지 업로드하면 기존 이미지는 덮어씌여짐. 굳이 삭제할 필요가 없음
        if let imageData = imageData {
            let newProfileImageURL = try await imageRepository.saveProfileImage(
                imageData: imageData,
                userUUID: user.userUUID
            )
            return user.setProfileImageURL(newProfileImageURL)
        }
        return user
    }
}
