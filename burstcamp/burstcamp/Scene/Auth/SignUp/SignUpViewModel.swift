//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import Foundation

final class SignUpViewModel {
    @Published var domain: Domain = .iOS
    var camperID: String = ""
    var blogAddress: String = ""
    let userUUID: String
    let nickname: String

    init(userUUID: String, nickname: String) {
        self.userUUID = userUUID
        self.nickname = nickname
    }
}
