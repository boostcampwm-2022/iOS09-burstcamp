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

    func checkBlogTitle(blogURL: String) -> String {
        return "목업"
    }

    private func getUser(userUUID: String, blogTitle: String) throws -> User {
        let signUpUser = signUpRepository.getSignUpUser()
        if let user = User(userUUID: userUUID, signUpUser: signUpUser, blogTitle: blogTitle) {
            return user
        } else {
            throw SignUpUseCaseError.createUser
        }
    }

    func signUp(_ user: User) {
    }

    func signUp(_ user: User, blogURL: String) {
    }

    func saveFCMToken(_ token: String) {
    }

    func isValidateBlogURL(_ blogURL: String) -> Bool {
        return false
    }
}
