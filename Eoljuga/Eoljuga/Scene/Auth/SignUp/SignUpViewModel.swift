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
}
