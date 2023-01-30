//
//  LoginProviderID.swift
//  burstcamp
//
//  Created by youtak on 2023/01/30.
//

import Foundation

enum LoginProvider {
    case github
    case apple
}

extension LoginProvider {
    var id: String {
        switch self {
        case .github: return "github.com"
        case .apple: return "apple.com"
        }
    }
}
