//
//  DefaultSignUpRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultSignUpRepository: SignUpRepository {

    private var signUpUser = SignUpUser()

    func setUserNickname(_ nickName: String) {
        signUpUser.setNickname(nickName)
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
}
