//
//  SignUpRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol SignUpRepository {
    func getSignUpUser() -> SignUpUser
    func setUserNickname(_ nickname: String)
    func setUserDomain(_ domain: Domain)
    func setUserCamperID(_ camperID: String)
    func setUserBlogURL(_ blogURL: String)
    func initUserBlogURL()
}
