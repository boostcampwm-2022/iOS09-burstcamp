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

    func isValidateBlogURL(_ blogURL: String) -> Bool
    func checkBlogTitle(blogURL: String) -> String
    func signUp(_ user: User)
    func signUp(_ user: User, blogURL: String)
    func saveFCMToken(_ token: String)
}
