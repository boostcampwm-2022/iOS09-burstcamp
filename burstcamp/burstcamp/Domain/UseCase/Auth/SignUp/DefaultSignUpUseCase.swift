//
//  DefaultSignUpUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultSignUpUseCase: SignUpUseCase {

    private let signUpRepository: SignUpRepository
    private let userRepository: UserRepository
    private let blogRepository: BlogRepository

    init(signUpRepository: SignUpRepository, userRepository: UserRepository, blogRepository: BlogRepository) {
        self.signUpRepository = signUpRepository
        self.userRepository = userRepository
        self.blogRepository = blogRepository
    }

    func setUserNickname(_ nickname: String) {
        signUpRepository.setUserNickname(nickname)
    }

    func setUserDomain(_ domain: Domain) {
        signUpRepository.setUserDomain(domain)
    }

    func setUserCamperID(_ camperID: String) {
        signUpRepository.setUserCamperID(camperID)
    }

    func setUserBlogURL(_ blogURL: String) {
        signUpRepository.setUserBlogURL(blogURL)
    }

    func getUserDomain() -> Domain {
        if let domain = signUpRepository.getSignUpUser().getDomain() {
            return domain
        }
        fatalError("캠퍼 ID 선택하는데 도메인이 없음")
    }

    func getUserBlogURL() -> String {
        return signUpRepository.getSignUpUser().getBlogURL()
    }

    func getBlogTitle(blogURL: String) async throws -> String {
        // 펑션으로 호출
        return try await blogRepository.checkBlogTitle(link: blogURL)
    }

    func getUser(userUUID: String, blogTitle: String = "") throws -> User {
        if blogTitle.isEmpty { signUpRepository.initUserBlogURL() }
        let signUpUser = signUpRepository.getSignUpUser()
        if let user = User(userUUID: userUUID, signUpUser: signUpUser, blogTitle: blogTitle) {
            return user
        } else {
            throw SignUpUseCaseError.createUser
        }
    }

    func signUp(_ user: User) async throws {
        // fireStore에 저장
    }

    func saveFCMToken(_ token: String, to userUUID: String) async throws {
        // fireStore에 저장
    }

    func isValidateBlogURL(_ blogURL: String) -> Bool {
        // blog 레포지토리에서 유효성 확인
        return false
    }
}
