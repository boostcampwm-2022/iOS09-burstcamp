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
    }

    func setUserBlogURL(_ blogURL: String) {
    }

    func isValidateEdit() -> Bool {
        // user & beforeUser 비교
        return false
    }

    func updateUser() {
        // isUserBlogURLChanged
        // update FirestorageImage
    }

    private func isUserChanged() -> Bool {
        return false
    }

    private func isUserBlogURLChanged() -> Bool {
        return false
    }

    private func updateFirestorageImage(_ image: Data) {
        // 기존 이미지가 있다면 삭제 (깃헙 링크의 경우 이미지가 없으므로 해당 x) -> github Image를 가입할 때 스토리지에 저장해야 할 듯
        // 새로운 이미지 업로드
    }
}
