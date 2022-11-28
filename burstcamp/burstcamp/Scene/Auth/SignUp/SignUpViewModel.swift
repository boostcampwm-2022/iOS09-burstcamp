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
    @Published var isValidateCamperID: Bool = false
    @Published var camperID: String = ""

    private var cancelBag = Set<AnyCancellable>()

    var blogAddress: String = ""
    let userUUID: String
    let nickname: String

    init(userUUID: String, nickname: String) {
        self.userUUID = userUUID
        self.nickname = nickname
        bind()
    }

    private func bind() {
        $camperID.sink { camperID in
            self.isValidateCamperID = camperID.count == 3 ? true : false
        }
        .store(in: &cancelBag)
    }
}
