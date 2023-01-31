//
//  DefaultMyPageEditUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultMyPageEditUseCase: MyPageEditUseCase {

    private var imageData: Data?
    private var beforeUser: User
    private var editedUser: User
    private let imageRepository: ImageRepository
    private let userRepository: UserRepository

    init(beforeUser: User, editedUser: User, imageRepository: ImageRepository, userRepository: UserRepository) {
        self.beforeUser = beforeUser
        self.editedUser = editedUser
        self.imageRepository = imageRepository
        self.userRepository = userRepository
    }

    convenience init(imageRepository: ImageRepository, userRepository: UserRepository) {
        let user = UserManager.shared.user
        self.init(beforeUser: user, editedUser: user, imageRepository: imageRepository, userRepository: userRepository)
    }

    func setUserNickname(_ nickname: String) {
        editedUser.setNickname(nickname)
    }

    func setUserBlogURL(_ blogURL: String) {
        editedUser.setBlogURL(blogURL)
    }

    func setImageData(_ imageData: Data?) {
        self.imageData = imageData
    }

    func validateResult() -> MyPageEditValidationResult {
        let nicknameValidation = Validator.validate(nickname: editedUser.nickname)
        let blogLinkValidation = Validator.validateIsEmpty(blogLink: editedUser.blogURL)
        if nicknameValidation && blogLinkValidation {
            return .validationOK
        } else if nicknameValidation {
            return .blogLinkError
        } else {
            return .nicknameError
        }
    }

    func updateUser() async throws {
        editedUser.setUpdateDate()
        try await updateFirestorageImage(imageData)
        try await userRepository.updateUser(editedUser)
    }

    private func isUserChanged() -> Bool {
        return editedUser != beforeUser
    }

    private func isUserBlogURLChanged() -> Bool {
        return editedUser.blogURL != beforeUser.blogURL
    }

    private func updateFirestorageImage(_ imageData: Data?) async throws {
        // 새로운 이미지 업로드하면 기존 이미지는 덮어씌여짐. 굳이 삭제할 필요가 없음
        if let imageData = imageData {
            let newProfileImageURL = try await imageRepository.saveProfileImage(
                imageData: imageData,
                userUUID: editedUser.userUUID
            )
            editedUser.setProfileImageURL(newProfileImageURL)
        }
    }
}
