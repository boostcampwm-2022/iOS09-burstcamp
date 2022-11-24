//
//  NickNameValidation.swift
//  burstcamp
//
//  Created by neuli on 2022/11/23.
//

import Foundation

struct NickNameValidation {

    static func validate(name: String) -> Bool {
        return name.isEmpty ? false : true
    }
}
