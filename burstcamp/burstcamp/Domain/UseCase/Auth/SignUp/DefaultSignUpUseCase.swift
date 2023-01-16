//
//  DefaultSignUpUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultSignUpUseCase: SignUpUseCase {

    private var signUpUser: SignUpUser
    private let userRepository: UserRepository
    private let blogRepository: BlogRepository

    init(userRepository: UserRepository, blogRepository: BlogRepository) {
        self.signUpUser = SignUpUser()
        self.userRepository = userRepository
        self.blogRepository = blogRepository
    }

    func setUserNickname(_ nickname: String) {
        signUpUser.setNickname(nickname)
    }

    func setUserDomain(_ domain: Domain) {
        signUpUser.setDomain(domain)
    }

    func setUserCamperID(_ camperID: String) {
        signUpUser.setCamperID(camperID)
    }

    func setUserBlogURL(_ blogURL: String) {
        signUpUser.setBlogURL(blogURL)
    }

    func getUserDomain() -> Domain {
        if let domain = signUpUser.getDomain() {
            return domain
        }
        fatalError("캠퍼 ID 선택하는데 도메인이 없음")
    }

    func getUserBlogURL() -> String {
        return signUpUser.getBlogURL()
    }

    func getBlogTitle(blogURL: String) async throws -> String {
        return try await blogRepository.checkBlogTitle(link: blogURL)
    }

    func getUser(userUUID: String, blogTitle: String = "") throws -> User {
        if blogTitle.isEmpty { signUpUser.initBlogURL() }
        let signUpUser = signUpUser
        if let user = User(userUUID: userUUID, signUpUser: signUpUser, blogTitle: blogTitle) {
            return user
        } else {
            throw SignUpUseCaseError.createUser
        }
    }

    func signUp(_ user: User) async throws {
        try await userRepository.saveUser(user)
    }

    func saveFCMToken(_ token: String, to userUUID: String) async throws {
        try await userRepository.saveFCMToken(token, to: userUUID)
    }

    func isValidateBlogURL(_ blogURL: String) -> Bool {
        return blogRepository.isValidateLink(blogURL)
    }
}
