//
//  SignUpUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol SignUpUseCase {
    func setUserNickname(_ nickname: String)
    func setUserDomain(_ domain: Domain)
    func setUserCamperID(_ camperID: String)
    func setUserBlogURL(_ blogURL: String)
    func getUserDomain() -> Domain

    func isValidateBlogURL(_ blogURL: String) -> Bool
    func getBlogTitle(blogURL: String) -> String
    func getUser(userUUID: String, blogTitle: String) throws -> User

    func signUp(_ user: User) async throws
    func saveFCMToken(_ token: String, to userUUID: String) async throws
}
